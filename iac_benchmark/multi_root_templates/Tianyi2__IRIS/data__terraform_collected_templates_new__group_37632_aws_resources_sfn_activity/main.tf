resource "aws_sfn_activity" "this" {
  name   = var.name
  region = var.region
  tags   = var.tags

  dynamic "encryption_configuration" {
    for_each = var.encryption_configuration != null ? [var.encryption_configuration] : []
    content {
      kms_key_id                        = encryption_configuration.value.kms_key_id
      type                              = encryption_configuration.value.type
      kms_data_key_reuse_period_seconds = encryption_configuration.value.kms_data_key_reuse_period_seconds
    }
  }
}