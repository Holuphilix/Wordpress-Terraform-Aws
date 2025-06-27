resource "aws_efs_file_system" "this" {
  creation_token = "${var.project}-efs"

  lifecycle_policy {
    transition_to_ia = "AFTER_7_DAYS"
  }

  tags = {
    Name    = "${var.project}-efs"
    Project = var.project
  }
}

resource "aws_security_group" "efs_sg" {
  name        = "${var.project}-efs-sg"
  description = "Allow NFS access from WordPress EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [var.wordpress_sg_id] # ✅ FIXED reference to variable
    description     = "Allow NFS from WordPress EC2 SG"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project}-efs-sg"
    Project = var.project
  }
}

resource "aws_efs_mount_target" "this" {
  for_each        = { for idx, subnet_id in var.subnet_ids : idx => subnet_id }
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.value
  security_groups = [aws_security_group.efs_sg.id] # ✅ Use this SG for mount targets
}

