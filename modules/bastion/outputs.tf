output "instance_id" {
  value = aws_instance.bastion.id
}

output "bastion_public_ip" {
  description = "The public IP of the bastion host"
  value       = aws_instance.bastion.public_ip
}

output "private_key_pem" {
  value       = var.private_key_pem
  sensitive   = true
  description = "Private key to SSH into instance"
}

output "ssh_sg_id" {
  value = module.ssh_sg.security_group_id
}
