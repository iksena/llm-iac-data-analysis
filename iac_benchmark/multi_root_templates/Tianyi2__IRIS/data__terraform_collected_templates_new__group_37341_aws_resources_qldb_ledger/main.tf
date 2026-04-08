resource "aws_qldb_ledger" "this" {
  region              = var.region
  deletion_protection = var.deletion_protection
  kms_key             = var.kms_key
  name                = var.name
  permissions_mode    = var.permissions_mode
  tags                = var.tags

  timeouts {
    create = var.timeouts_create
    delete = var.timeouts_delete
  }
}