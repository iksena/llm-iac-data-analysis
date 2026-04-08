resource "aws_docdb_event_subscription" "this" {
  region           = var.region
  name             = var.name
  name_prefix      = var.name_prefix
  sns_topic_arn    = var.sns_topic
  source_ids       = var.source_ids
  source_type      = var.source_type
  event_categories = var.event_categories
  enabled          = var.enabled
  tags             = var.tags

  timeouts {
    create = var.timeouts_create
    delete = var.timeouts_delete
    update = var.timeouts_update
  }
}