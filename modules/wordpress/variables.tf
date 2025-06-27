variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "bastion_sg_id" {
  type        = string
  description = "Security Group ID of the Bastion host"
}
