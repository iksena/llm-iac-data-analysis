resource "aws_verifiedaccess_group" "this" {
  verifiedaccess_instance_id = var.verifiedaccess_instance_id
  region                     = var.region
  description                = var.description
  policy_document            = var.policy_document
  tags                       = var.tags

  dynamic "sse_configuration" {
    for_each = var.sse_configuration != null ? [var.sse_configuration] : []
    content {
      customer_managed_key_enabled = sse_configuration.value.customer_managed_key_enabled
      kms_key_arn                  = sse_configuration.value.kms_key_arn
    }
  }

}