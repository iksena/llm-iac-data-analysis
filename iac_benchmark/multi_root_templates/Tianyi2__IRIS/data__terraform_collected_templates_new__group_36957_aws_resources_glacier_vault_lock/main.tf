resource "aws_glacier_vault_lock" "this" {
  region                = var.region
  complete_lock         = var.complete_lock
  policy                = var.policy
  vault_name            = var.vault_name
  ignore_deletion_error = var.ignore_deletion_error
}