resource "aws_autoscaling_lifecycle_hook" "this" {
  region                  = var.region
  name                    = var.name
  autoscaling_group_name  = var.autoscaling_group_name
  default_result          = var.default_result
  heartbeat_timeout       = var.heartbeat_timeout
  lifecycle_transition    = var.lifecycle_transition
  notification_metadata   = var.notification_metadata
  notification_target_arn = var.notification_target_arn
  role_arn                = var.role_arn
}