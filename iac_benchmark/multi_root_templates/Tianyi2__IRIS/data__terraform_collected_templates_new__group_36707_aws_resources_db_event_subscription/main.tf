resource "aws_db_event_subscription" "this" {
  region           = var.region
  name             = var.name
  name_prefix      = var.name_prefix
  sns_topic        = var.sns_topic
  source_ids       = var.source_ids
  source_type      = var.source_type
  event_categories = var.event_categories
  enabled          = var.enabled
  tags             = var.tags

  timeouts {
    create = "40m"
    delete = "40m"
    update = "40m"
  }
}