resource "aws_sfn_state_machine" "this" {
  region      = var.region
  definition  = var.definition
  name        = var.name
  name_prefix = var.name_prefix
  publish     = var.publish
  role_arn    = var.role_arn
  tags        = var.tags
  type        = var.type

  dynamic "encryption_configuration" {
    for_each = var.encryption_configuration != null ? [var.encryption_configuration] : []
    content {
      kms_key_id                        = encryption_configuration.value.kms_key_id
      type                              = encryption_configuration.value.type
      kms_data_key_reuse_period_seconds = encryption_configuration.value.kms_data_key_reuse_period_seconds
    }
  }

  dynamic "logging_configuration" {
    for_each = var.logging_configuration != null ? [var.logging_configuration] : []
    content {
      include_execution_data = logging_configuration.value.include_execution_data
      level                  = logging_configuration.value.level
      log_destination        = logging_configuration.value.log_destination
    }
  }

  dynamic "tracing_configuration" {
    for_each = var.tracing_configuration != null ? [var.tracing_configuration] : []
    content {
      enabled = tracing_configuration.value.enabled
    }
  }

  timeouts {
    create = "5m"
    update = "1m"
    delete = "5m"
  }
}