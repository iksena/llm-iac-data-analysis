resource "aws_neptune_event_subscription" "this" {
  region           = var.region
  enabled          = var.enabled
  event_categories = var.event_categories
  name             = var.name
  name_prefix      = var.name_prefix
  sns_topic_arn    = var.sns_topic_arn
  source_ids       = var.source_ids
  source_type      = var.source_type
  tags             = var.tags

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      update = timeouts.value.update
    }
  }
}