output "eip_id" {
  value = aws_eip.this.id
}

output "eip_public_ip" {
  value = aws_eip.this.public_ip
}
