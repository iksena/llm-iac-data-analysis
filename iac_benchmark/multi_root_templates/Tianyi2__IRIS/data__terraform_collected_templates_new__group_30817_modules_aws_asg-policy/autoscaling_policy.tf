resource "aws_autoscaling_policy" "ecs_cpu_scale_out_policy" {
  count = var.enable_scale_out_on_cpu ? 1 : 0
  name = "${var.cluster_name}-${var.cluster_environment}-cpu-scale-out-policy"
  autoscaling_group_name = var.autoscaling_group_name
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = "1" # +1
  cooldown = "300"
  policy_type = "SimpleScaling"
}