resource "aws_backup_vault_policy" "this" {
  region            = var.region
  backup_vault_name = var.backup_vault_name
  policy            = var.policy
}