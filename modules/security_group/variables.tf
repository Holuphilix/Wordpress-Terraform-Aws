variable "name" {
  type        = string
  description = "Name of the security group"
}

variable "description" {
  type        = string
  description = "Description of the security group"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID to associate with the security group"
}

variable "ingress_rules" {
  type = list(object({
    from_port               = number
    to_port                 = number
    protocol                = string
    cidr_blocks             = optional(list(string))
    source_security_group_id = optional(string)
  }))
  description = "List of ingress rules for the security group"
}

