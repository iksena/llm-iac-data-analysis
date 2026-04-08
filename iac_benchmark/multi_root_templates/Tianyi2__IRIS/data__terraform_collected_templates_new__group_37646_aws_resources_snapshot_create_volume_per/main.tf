resource "aws_snapshot_create_volume_permission" "this" {
  region      = var.region
  snapshot_id = var.snapshot_id
  account_id  = var.account_id
}