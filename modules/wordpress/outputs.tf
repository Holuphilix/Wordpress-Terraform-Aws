output "security_group_id" {
  description = "The WordPress Security Group ID"
  value       = aws_security_group.wordpress_sg.id
}
