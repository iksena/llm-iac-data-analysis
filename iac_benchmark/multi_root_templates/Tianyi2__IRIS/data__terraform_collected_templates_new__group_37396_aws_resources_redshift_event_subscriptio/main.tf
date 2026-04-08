resource "aws_redshift_event_subscription" "this" {
  region           = var.region
  name             = var.name
  sns_topic_arn    = var.sns_topic_arn
  source_ids       = var.source_ids
  source_type      = var.source_type
  severity         = var.severity
  event_categories = var.event_categories
  enabled          = var.enabled
  tags             = var.tags
}