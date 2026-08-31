
data "aws_caller_identity" "current" {}

resource "aws_kms_key" "aws_backup_key" {
  description             = "AWS Backup KMS key"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}

resource "aws_backup_vault" "backup_vault" {
  name        = var.vault_name
  kms_key_arn = aws_kms_key.aws_backup_key.arn
}

resource "aws_backup_plan" "backup_plan" {
  name = "${var.vault_name}-backup-plan"

  rule {
    rule_name         = "${var.vault_name}-backup-rule"
    target_vault_name = aws_backup_vault.backup_vault.name
    schedule          = var.schedule
    start_window      = var.start_window
    completion_window = var.completion_window

    lifecycle {
      delete_after = var.backups_expire_days
    }
  }
}

resource "aws_backup_selection" "backup_plan_selection" {
  iam_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/service-role/AWSBackupDefaultServiceRole"
  name         = "${var.vault_name}-backup-rule-tag-selection"
  plan_id      = aws_backup_plan.backup_plan.id
  resources    = ["*"]

  condition {
    string_equals {
      key   = "aws:ResourceTag/${var.backup_tag}"
      value = "true"
    }
  }
}

resource "aws_backup_vault_lock_configuration" "backup_vault_lock_configuration" {
  backup_vault_name   = aws_backup_vault.backup_vault.name
  
  changeable_for_days = 3  # This configuration makes the vault forever immutable after 3 days

  min_retention_days  = var.min_retention_days
  max_retention_days  = var.max_retention_days
}
