# VPC Module
module "vpc" {
  source               = "./modules/vpc"

  vpc_name             = var.vpc_name
  project              = var.project
  vpc_cidr             = var.vpc_cidr

  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

# Elastic IP Module for NAT Gateway
module "eip" {
  source = "./modules/eip"
}

# NAT Gateway Module
module "nat_gw" {
  source           = "./modules/nat_gateway"
  public_subnet_id = module.vpc.public_subnet_ids[0]
  allocation_id    = module.eip.eip_id
}

# Route Tables for Private Subnets
resource "aws_route_table" "private" {
  count  = length(module.vpc.private_subnet_ids)
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = module.nat_gw.nat_gateway_id
  }

  tags = {
    Name    = "${var.vpc_name}-private-rt-${count.index + 1}"
    Project = var.project
  }
}

# Associate Route Tables with Private Subnets
resource "aws_route_table_association" "private" {
  count          = length(module.vpc.private_subnet_ids)
  subnet_id      = module.vpc.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private[count.index].id
}

# WordPress Security Group Module
module "wordpress_sg" {
  source         = "./modules/wordpress"
  vpc_id         = module.vpc.vpc_id
  bastion_sg_id  = module.bastion.ssh_sg_id
}

# RDS Module
module "rds" {
  source             = "./modules/rds"
  project            = var.project
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  web_sg_id          = module.wordpress_sg.security_group_id  # Use WordPress SG here
  db_username        = var.db_username
  db_password        = var.db_password
}

# Bastion Host Module
module "bastion" {
  source         = "./modules/bastion"
  vpc_id         = module.vpc.vpc_id
  subnet_id      = module.vpc.public_subnet_ids[0]
  my_ip_cidr     = var.my_ip_cidr
  ami_id         = var.bastion_ami
  instance_type  = "t2.micro"
  key_name       = aws_key_pair.wordpress_key.key_name
  private_key_pem= tls_private_key.wordpress_key.private_key_pem
}

# ALB Security Group Module (optional if separate)
module "alb_sg" {
  source      = "./modules/security_group"
  name        = "alb_sg"
  description = "Allow traffic from anywhere"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

# ALB Module
module "alb" {
  source             = "./modules/alb"
  name               = "wordpress-alb"
  internal           = false
  load_balancer_type = "application"
  subnet_ids         = module.vpc.public_subnet_ids
  security_group_ids = [module.alb_sg.security_group_id]
  vpc_id             = module.vpc.vpc_id
}

module "efs" {
  source              = "./modules/efs"
  project             = var.project
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
  wordpress_sg_id     = var.wordpress_sg_id   # ✅ NEW
  aws_region          = var.aws_region        # ✅ NEW
}

module "asg" {
  source              = "./modules/asg"
  project             = var.project
  ami_id              = var.wordpress_ami
  instance_type       = "t2.micro"
  key_name            = aws_key_pair.wordpress_key.key_name
  private_key_pem     = tls_private_key.wordpress_key.private_key_pem
  efs_dns_name        = module.efs.efs_dns_name
  db_name             = var.db_name
  db_username         = var.db_username
  db_password         = var.db_password
  db_host             = module.rds.db_endpoint
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [module.wordpress_sg.security_group_id]  # Use WordPress SG
  target_group_arn    = module.alb.target_group_arn
  desired_capacity    = 1
  min_size            = 1
  max_size            = 2
}

# Generate SSH key pair
resource "tls_private_key" "wordpress_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "wordpress_key" {
  key_name   = "wordpress-key"
  public_key = tls_private_key.wordpress_key.public_key_openssh
}

resource "local_file" "private_key_pem" {
  content              = tls_private_key.wordpress_key.private_key_pem
  filename             = "${path.module}/wordpress-key.pem"
  file_permission      = "0600"
  directory_permission = "0700"
}
