variable "project" {
  type        = string
  description = "Project name for tagging"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for EC2 instance"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
}

variable "efs_dns_name" {
  description = "The DNS name of the EFS to mount"
  type        = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Database password"
}

variable "db_host" {
  type = string
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security Group IDs to attach to the EC2 instance"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets for the Auto Scaling Group"
}

variable "desired_capacity" {
  type        = number
  default     = 1
}

variable "min_size" {
  type        = number
  default     = 1
}

variable "max_size" {
  type        = number
  default     = 2
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "private_key_pem" {
  description = "Private key content for SSH access"
  type        = string
  sensitive   = true
}
variable "target_group_arn" {
  description = "The ARN of the target group to attach to the ASG"
  type        = string
}
