#######################################
# Bastion Host Security Group Module
#######################################
module "ssh_sg" {
  source      = "../security_group"
  name        = "bastion-ssh-sg"
  description = "Allow SSH access from your IP"
  vpc_id      = var.vpc_id

  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.my_ip_cidr]
    }
  ]
}

#######################################
# Application Load Balancer Security Group
#######################################
module "alb_sg" {
  source      = "../security_group"
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from anywhere
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  # Allow HTTPS from anywhere
    }
  ]
}

#######################################
# Bastion EC2 Instance
#######################################
resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [module.ssh_sg.security_group_id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    Name = "BastionHost"
  }
}
