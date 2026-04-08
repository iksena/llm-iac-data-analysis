resource "aws_cloudwatch_event_bus" "this" {
  name               = var.name
  region             = var.region
  description        = var.description
  event_source_name  = var.event_source_name
  kms_key_identifier = var.kms_key_identifier
  tags               = var.tags

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_config != null ? [var.dead_letter_config] : []
    content {
      arn = dead_letter_config.value.arn
    }
  }

  dynamic "log_config" {
    for_each = var.log_config != null ? [var.log_config] : []
    content {
      include_detail = log_config.value.include_detail
      level          = log_config.value.level
    }
  }
}