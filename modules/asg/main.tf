resource "aws_launch_template" "this" {
  name_prefix   = "${var.project}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name  # Ensure key exists in AWS

  # User data script, base64-encoded
  user_data = base64encode(templatefile("${path.root}/user_data.sh.tpl", {
    efs_dns_name = var.efs_dns_name
    db_name      = var.db_name
    db_username  = var.db_username
    db_password  = var.db_password
    db_host      = var.db_host
  }))

  vpc_security_group_ids = var.security_group_ids

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name    = "${var.project}-wordpress"
      Project = var.project
    }
  }
}

resource "aws_autoscaling_group" "this" {
  name                      = "${var.project}-asg"
  desired_capacity           = var.desired_capacity
  min_size                   = var.min_size
  max_size                   = var.max_size
  vpc_zone_identifier        = var.subnet_ids  # Use private subnet IDs
  health_check_type          = "EC2"
  health_check_grace_period  = 300
  force_delete               = true
  target_group_arns          = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"  # Correct usage — string literal $Latest
  }

  tag {
    key                 = "Name"
    value               = "${var.project}-wordpress"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
