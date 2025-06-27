resource "aws_db_subnet_group" "rds_subnet" {
  name       = "${var.project}-rds-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = {
    Name = "${var.project}-rds-subnet-group"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "${var.project}-db-sg"
  description = "Allow MySQL access from webservers"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.web_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-db-sg"
  }
}

resource "aws_db_instance" "wordpress_db" {
  identifier               = "${var.project}-db"
  engine                   = "mysql"
  engine_version           = "8.0"
  instance_class           = var.instance_class
  allocated_storage        = var.allocated_storage
  storage_type             = var.storage_type
  db_name                     = var.db_name
  username                 = var.db_username
  password                 = var.db_password
  db_subnet_group_name     = aws_db_subnet_group.rds_subnet.name
  vpc_security_group_ids   = [aws_security_group.db_sg.id]
  skip_final_snapshot      = true
  publicly_accessible      = false
  multi_az                 = var.multi_az
}
