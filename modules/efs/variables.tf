variable "project" {
  type        = string
  description = "Project name for tagging"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where EFS and SG will be created"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets to create EFS mount targets in"
}

variable "wordpress_sg_id" {
  type        = string
  description = "Security Group ID of the WordPress EC2 instance"
}

variable "aws_region" {
  type        = string
  description = "AWS region (used to construct DNS)"
}
