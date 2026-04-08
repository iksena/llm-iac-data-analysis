resource "aws_autoscaling_group" "bastion" {
  name                      = "${var.name} - ${aws_launch_configuration.bastion.name}"
  vpc_zone_identifier       = var.private_subnets
  desired_capacity          = "1"
  min_size                  = "1"
  max_size                  = "1"
  health_check_grace_period = "60"
  health_check_type         = "ELB"
  force_delete              = false
  wait_for_capacity_timeout = 0
  launch_configuration      = aws_launch_configuration.bastion.name
  target_group_arns         = [aws_lb_target_group.bastion.arn]
  enabled_metrics = [
    "GroupInServiceInstances",
    "GroupTotalInstances",
  ]
  tags = [
    {
      "key"                 = "Name"
      "value"               = var.name
      "propagate_at_launch" = "true"
    },
  ]
  lifecycle {
    create_before_destroy = true
  }
}
