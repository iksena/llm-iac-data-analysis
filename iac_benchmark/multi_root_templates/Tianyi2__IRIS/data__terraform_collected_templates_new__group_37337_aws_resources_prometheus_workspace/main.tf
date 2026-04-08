resource "aws_prometheus_workspace" "this" {
  region      = var.region
  alias       = var.alias
  kms_key_arn = var.kms_key_arn

  dynamic "logging_configuration" {
    for_each = var.logging_configuration != null ? [var.logging_configuration] : []
    content {
      log_group_arn = logging_configuration.value.log_group_arn
    }
  }

  tags = var.tags
}