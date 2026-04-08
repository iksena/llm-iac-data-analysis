resource "aws_autoscaling_notification" "this" {
  region        = var.region
  group_names   = var.group_names
  notifications = var.notifications
  topic_arn     = var.topic_arn
}