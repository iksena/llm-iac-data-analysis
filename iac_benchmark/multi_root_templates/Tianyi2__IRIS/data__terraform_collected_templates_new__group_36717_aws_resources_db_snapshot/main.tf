resource "aws_db_snapshot" "this" {
  region                 = var.region
  db_instance_identifier = var.db_instance_identifier
  db_snapshot_identifier = var.db_snapshot_identifier
  shared_accounts        = var.shared_accounts
  tags                   = var.tags

  timeouts {
    create = var.timeouts_create
  }
}