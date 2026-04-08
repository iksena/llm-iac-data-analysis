resource "aws_redshift_integration" "this" {
  integration_name              = var.integration_name
  source_arn                    = var.source_arn
  target_arn                    = var.target_arn
  region                        = var.region
  additional_encryption_context = var.additional_encryption_context
  description                   = var.description
  kms_key_id                    = var.kms_key_id
  tags                          = var.tags

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }
}