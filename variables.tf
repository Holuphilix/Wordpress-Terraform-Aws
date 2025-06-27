# ---------------------------------------
# 📌 Project Metadata
# ---------------------------------------
variable "project" {
  description = "Project name used for tagging resources"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

# ---------------------------------------
# 🌐 VPC Configuration
# ---------------------------------------
variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "List of Availability Zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs (from output or state)"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs (from output or state)"
  type        = list(string)
}

variable "subnet_ids" {
  description = "Subnet IDs used by ASG"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID of the VPC (from output or remote state)"
  type        = string
}

# ---------------------------------------
# 🔐 Key Pair and Security Groups
# ---------------------------------------
variable "key_name" {
  description = "Name of the EC2 Key Pair"
  type        = string
}

variable "private_key_file" {
  description = "Path to the private key PEM file for SSH access"
  type        = string
}

variable "my_ip_cidr" {
  description = "Your IP address in CIDR notation for SSH access to bastion"
  type        = string
}

variable "security_group_id" {
  description = "Single security group ID used by EC2 or RDS"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs (used in ASG)"
  type        = list(string)
}

variable "efs_sg_id" {
  description = "Security group ID associated with EFS"
  type        = string
}

# ---------------------------------------
# 💻 AMI IDs
# ---------------------------------------
variable "bastion_ami" {
  description = "AMI ID for Bastion host"
  type        = string
}

variable "wordpress_ami" {
  description = "AMI ID for WordPress instance (used in ASG)"
  type        = string
}

variable "ami_id" {
  description = "General AMI ID (can be used in other modules if needed)"
  type        = string
}

# ---------------------------------------
# 🗃️ RDS Credentials
# ---------------------------------------
variable "db_name" {
  description = "Database name for WordPress"
  type        = string
  default     = "wordpress"
}

variable "db_username" {
  description = "Database username for WordPress"
  type        = string
}

variable "db_password" {
  description = "Database password for WordPress"
  type        = string
  sensitive   = true
}

variable "db_host" {
  description = "Endpoint/hostname of the RDS database"
  type        = string
}

# ---------------------------------------
# 📂 EFS
# ---------------------------------------
variable "efs_dns_name" {
  description = "DNS name for EFS mount target"
  type        = string
}

variable "efs_id" {
  description = "EFS ID (used optionally in outputs or mounts)"
  type        = string
}

variable "efs_allowed_cidrs" {
  description = "List of CIDRs allowed to access EFS"
  type        = list(string)
  default     = []
}

# ---------------------------------------
# ⚙️ ASG Configuration
# ---------------------------------------
variable "instance_type" {
  description = "EC2 instance type for the WordPress server"
  type        = string
  default     = "t2.micro"
}

variable "desired_capacity" {
  description = "ASG desired number of instances"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "ASG minimum number of instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "ASG maximum number of instances"
  type        = number
  default     = 2
}

variable "target_group_arn" {
  description = "Target group ARN for ALB"
  type        = string
}

# ---------------------------------------
# 🌐 ALB / Bastion
# ---------------------------------------
variable "alb_dns_name" {
  description = "DNS name of the ALB"
  type        = string
}

variable "bastion_public_ip" {
  description = "Public IP of the bastion instance"
  type        = string
}

# ---------------------------------------
# 🌐 NAT Gateway / EIP
# ---------------------------------------
variable "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  type        = string
}

variable "eip_id" {
  description = "Elastic IP ID used by the NAT Gateway"
  type        = string
}

variable "wordpress_sg_id" {
  description = "Security Group ID for WordPress EC2 instance"
  type        = string
}
