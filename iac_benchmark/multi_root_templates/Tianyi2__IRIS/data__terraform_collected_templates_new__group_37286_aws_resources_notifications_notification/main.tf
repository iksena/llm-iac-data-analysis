resource "aws_notifications_notification_configuration" "this" {
  name                 = var.name
  description          = var.description
  aggregation_duration = var.aggregation_duration

  tags = var.tags
}