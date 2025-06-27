resource "aws_nat_gateway" "this" {
  allocation_id = var.allocation_id
  subnet_id     = var.public_subnet_id

  tags = {
    Name = "Wordpress-based-nat-gateway"
  }

  depends_on = [] # Optional or remove if not depending on anything specific
}
