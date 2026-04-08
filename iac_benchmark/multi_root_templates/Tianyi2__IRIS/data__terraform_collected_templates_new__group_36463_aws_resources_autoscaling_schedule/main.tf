resource "aws_autoscaling_schedule" "this" {
  autoscaling_group_name = var.autoscaling_group_name
  scheduled_action_name  = var.scheduled_action_name
  region                 = var.region
  desired_capacity       = var.desired_capacity
  end_time               = var.end_time
  max_size               = var.max_size
  min_size               = var.min_size
  recurrence             = var.recurrence
  start_time             = var.start_time
  time_zone              = var.time_zone
}