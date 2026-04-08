resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  count = var.create_alarm_on_cpu_usage ? 1 : 0
  alarm_name = var.cpu_alarm_name
  alarm_description = "Alarm on CPU usage for ${var.cluster_name}-${var.cluster_environment}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "${var.cpu_threshold}"
  dimensions = {
    "AutoScalingGroupName" = "${var.autoscaling_group_name}"
  }
  actions_enabled = var.cpu_actions_enabled
  alarm_actions = [aws_autoscaling_policy.ecs_cpu_policy.arn]
}