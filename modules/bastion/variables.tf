variable "vpc_id" {
  description = "VPC ID for bastion SGs"
  type        = string
}
variable "ami_id" {}
variable "instance_type" {
  default = "t2.micro"
}
variable "subnet_id" {}
variable "my_ip_cidr" {}  # e.g. 102.89.34.12/32
variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "private_key_pem" {
  description = "Private key content for SSH access"
  type        = string
  sensitive   = true
}
