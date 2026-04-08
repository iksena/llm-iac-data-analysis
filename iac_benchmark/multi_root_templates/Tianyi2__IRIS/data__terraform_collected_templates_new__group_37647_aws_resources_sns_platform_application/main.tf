resource "aws_sns_platform_application" "this" {
  name                             = var.name
  platform                         = var.platform
  platform_credential              = var.platform_credential
  region                           = var.region
  event_delivery_failure_topic_arn = var.event_delivery_failure_topic_arn
  event_endpoint_created_topic_arn = var.event_endpoint_created_topic_arn
  event_endpoint_deleted_topic_arn = var.event_endpoint_deleted_topic_arn
  event_endpoint_updated_topic_arn = var.event_endpoint_updated_topic_arn
  failure_feedback_role_arn        = var.failure_feedback_role_arn
  platform_principal               = var.platform_principal
  success_feedback_role_arn        = var.success_feedback_role_arn
  success_feedback_sample_rate     = var.success_feedback_sample_rate
  apple_platform_team_id           = var.apple_platform_team_id
  apple_platform_bundle_id         = var.apple_platform_bundle_id
}