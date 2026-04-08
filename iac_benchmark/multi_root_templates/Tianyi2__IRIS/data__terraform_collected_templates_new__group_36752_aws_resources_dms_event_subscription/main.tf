resource "aws_dms_event_subscription" "this" {
  region           = var.region
  name             = var.name
  enabled          = var.enabled
  event_categories = var.event_categories
  sns_topic_arn    = var.sns_topic_arn
  source_ids       = var.source_ids
  source_type      = var.source_type
  tags             = var.tags

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}