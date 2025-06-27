resource "aws_eip" "this" {
  domain = "vpc"  # Use 'domain' instead of the deprecated 'vpc'
}

