resource "aws_backup_vault" "this" {
  name          = var.name
  region        = var.region
  force_destroy = var.force_destroy
  kms_key_arn   = var.kms_key_arn
  tags          = var.tags

  timeouts {
    delete = "10m"
  }
}