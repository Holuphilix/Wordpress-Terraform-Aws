#!/bin/bash
set -e

# Redirect all output to log file and system logger
exec > >(tee /var/log/user_data.log | logger -t user-data -s 2>/dev/console) 2>&1

echo "🚀 Starting WordPress user data script at $(date)"

# Update and install packages
apt-get update -y
apt-get install -y apache2 php php-mysql mysql-client nfs-common unzip wget curl

# Enable and start Apache
systemctl enable apache2
systemctl start apache2

# Create WordPress root directory
mkdir -p /var/www/html

# Retry mounting EFS with up to 5 attempts
MAX_RETRIES=5
count=0
until mountpoint -q /var/www/html || [ $count -ge $MAX_RETRIES ]; do
  echo "Mounting EFS attempt $((count+1))..."
  mount -t nfs4 -o nfsvers=4.1 ${efs_dns_name}:/ /var/www/html && break
  count=$((count+1))
  sleep 5
done

if mountpoint -q /var/www/html; then
  echo "✅ EFS mounted successfully"
else
  echo "❌ Failed to mount EFS after $MAX_RETRIES attempts" >&2
  exit 1
fi

# Persist EFS mount in fstab if not already present
if ! grep -q "${efs_dns_name}:/ /var/www/html" /etc/fstab; then
  echo "${efs_dns_name}:/ /var/www/html nfs4 defaults,_netdev 0 0" >> /etc/fstab
  echo "✅ Added EFS mount to /etc/fstab"
fi

# Download and install WordPress if not already installed on EFS
if [ ! -f /var/www/html/wp-config.php ]; then
  echo "⬇️ Downloading WordPress..."
  cd /tmp
  wget https://wordpress.org/latest.tar.gz
  tar -xzf latest.tar.gz
  cp -r wordpress/* /var/www/html/
  sync
  rm -rf latest.tar.gz wordpress
  echo "✅ WordPress downloaded and copied to EFS"
else
  echo "ℹ️ WordPress already installed on EFS, skipping download"
fi

# Set ownership and permissions for Apache
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Fetch WordPress salts securely
echo "🔐 Fetching WordPress salts..."
WP_SALTS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/ || echo "# Failed to fetch salts")

# Create wp-config.php with DB credentials and salts
cat > /var/www/html/wp-config.php <<EOF
<?php
define('DB_NAME', '${db_name}');
define('DB_USER', '${db_username}');
define('DB_PASSWORD', '${db_password}');
define('DB_HOST', '${db_host}');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

\$table_prefix = 'wp_';
define('WP_DEBUG', false);

$(echo "$WP_SALTS")

if (!defined('ABSPATH'))
    define('ABSPATH', dirname(__FILE__) . '/');

require_once(ABSPATH . 'wp-settings.php');
EOF

# Restart Apache to apply changes
systemctl restart apache2

echo "✅ WordPress setup completed on $(date)"
