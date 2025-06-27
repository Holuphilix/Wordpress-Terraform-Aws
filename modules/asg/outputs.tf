output "asg_name" {
  value       = aws_autoscaling_group.this.name
  description = "Name of the Auto Scaling Group"
}

output "private_key_pem" {
  value       = var.private_key_pem
  sensitive   = true
  description = "Private key to SSH into instance"
}
