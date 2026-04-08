resource "aws_appconfig_environment" "this" {
  region         = var.region
  application_id = var.application_id
  name           = var.name
  description    = var.description

  dynamic "monitor" {
    for_each = var.monitor
    content {
      alarm_arn      = monitor.value.alarm_arn
      alarm_role_arn = monitor.value.alarm_role_arn
    }
  }

  tags = var.tags
}