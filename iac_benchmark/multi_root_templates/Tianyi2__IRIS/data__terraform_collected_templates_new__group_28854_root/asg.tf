resource "aws_autoscaling_group" "bastion" {
  name_prefix               = var.name
  vpc_zone_identifier       = var.private_subnets
  desired_capacity          = "1"
  min_size                  = "1"
  max_size                  = "1"
  health_check_grace_period = "60"
  health_check_type         = "ELB"
  force_delete              = false
  wait_for_capacity_timeout = 0
  target_group_arns         = [aws_lb_target_group.bastion.arn]

  launch_template {
    id      = aws_launch_template.bastion.id
    version = "$Latest"
  }

  enabled_metrics = [
    "GroupInServiceInstances",
    "GroupTotalInstances",
  ]

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = "true"
  }

  instance_refresh {
    strategy = "Rolling"
  }

  lifecycle {
    create_before_destroy = true
  }
}
