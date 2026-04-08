resource "aws_devopsguru_notification_channel" "this" {
  sns {
    topic_arn = var.sns_topic_arn
  }

  region = var.region

  dynamic "filters" {
    for_each = var.filters != null ? [var.filters] : []
    content {
      message_types = filters.value.message_types
      severities    = filters.value.severities
    }
  }
}