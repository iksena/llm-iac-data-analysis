resource "aws_rds_integration" "this" {
  integration_name = var.integration_name
  source_arn       = var.source_arn
  target_arn       = var.target_arn

  additional_encryption_context = var.additional_encryption_context
  data_filter                   = var.data_filter
  kms_key_id                    = var.kms_key_id
  tags                          = var.tags

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
    }
  }
}