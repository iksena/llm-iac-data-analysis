resource "aws_kms_grant" "this" {
  region                = var.region
  name                  = var.name
  key_id                = var.key_id
  grantee_principal     = var.grantee_principal
  operations            = var.operations
  retiring_principal    = var.retiring_principal
  grant_creation_tokens = var.grant_creation_tokens
  retire_on_delete      = var.retire_on_delete

  dynamic "constraints" {
    for_each = var.constraints != null ? [var.constraints] : []
    content {
      encryption_context_equals = constraints.value.encryption_context_equals
      encryption_context_subset = constraints.value.encryption_context_subset
    }
  }
}