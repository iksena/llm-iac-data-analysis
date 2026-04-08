resource "aws_redshift_snapshot_copy_grant" "this" {
  region                   = var.region
  snapshot_copy_grant_name = var.snapshot_copy_grant_name
  kms_key_id               = var.kms_key_id
  tags                     = var.tags
}