resource "aws_ses_identity_notification_topic" "this" {
  region                   = var.region
  topic_arn                = var.topic_arn
  notification_type        = var.notification_type
  identity                 = var.identity
  include_original_headers = var.include_original_headers
}