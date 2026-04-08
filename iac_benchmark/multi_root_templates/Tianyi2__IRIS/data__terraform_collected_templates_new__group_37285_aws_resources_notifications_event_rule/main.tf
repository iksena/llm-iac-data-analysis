resource "aws_notifications_event_rule" "this" {
  event_pattern                  = var.event_pattern
  event_type                     = var.event_type
  notification_configuration_arn = var.notification_configuration_arn
  regions                        = var.regions
  source                         = var.event_source
}