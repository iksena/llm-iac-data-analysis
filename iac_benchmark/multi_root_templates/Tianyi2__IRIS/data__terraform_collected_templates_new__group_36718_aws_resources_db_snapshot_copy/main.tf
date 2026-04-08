resource "aws_db_snapshot_copy" "this" {
  region                          = var.region
  copy_tags                       = var.copy_tags
  destination_region              = var.destination_region
  kms_key_id                      = var.kms_key_id
  option_group_name               = var.option_group_name
  presigned_url                   = var.presigned_url
  shared_accounts                 = var.shared_accounts
  source_db_snapshot_identifier   = var.source_db_snapshot_identifier
  target_custom_availability_zone = var.target_custom_availability_zone
  target_db_snapshot_identifier   = var.target_db_snapshot_identifier
  tags                            = var.tags

  timeouts {
    create = var.create_timeout
  }
}