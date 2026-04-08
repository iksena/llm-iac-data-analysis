resource "aws_notifications_channel_association" "this" {
  arn                            = var.arn
  notification_configuration_arn = var.notification_configuration_arn
}