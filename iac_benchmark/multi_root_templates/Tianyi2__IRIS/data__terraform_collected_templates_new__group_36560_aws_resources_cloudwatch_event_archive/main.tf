resource "aws_cloudwatch_event_archive" "this" {
  region             = var.region
  name               = var.name
  event_source_arn   = var.event_source_arn
  description        = var.description
  event_pattern      = var.event_pattern
  kms_key_identifier = var.kms_key_identifier
  retention_days     = var.retention_days
}