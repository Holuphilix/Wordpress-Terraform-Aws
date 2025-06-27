output "db_endpoint" {
  description = "RDS endpoint for application"
  value       = aws_db_instance.wordpress_db.endpoint
}

output "db_security_group_id" {
  description = "ID of the RDS security group"
  value       = aws_security_group.db_sg.id
}
