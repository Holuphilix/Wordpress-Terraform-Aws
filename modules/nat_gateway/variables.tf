variable "public_subnet_id" {
  description = "The public subnet ID to place the NAT Gateway"
  type        = string
}

variable "allocation_id" {
  description = "Elastic IP allocation ID"
  type        = string
}
