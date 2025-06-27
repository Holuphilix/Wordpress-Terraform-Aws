# Output the DNS name of the ALB
output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.wordpress_alb.dns_name
}

# Output the ARN of the Target Group
output "target_group_arn" {
  description = "The ARN of the Target Group"
  value       = aws_lb_target_group.wordpress_tg.arn
}
