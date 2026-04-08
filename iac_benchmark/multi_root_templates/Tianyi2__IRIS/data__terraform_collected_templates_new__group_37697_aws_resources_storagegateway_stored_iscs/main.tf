resource "aws_storagegateway_stored_iscsi_volume" "this" {
  region                 = var.region
  gateway_arn            = var.gateway_arn
  network_interface_id   = var.network_interface_id
  target_name            = var.target_name
  disk_id                = var.disk_id
  preserve_existing_data = var.preserve_existing_data
  snapshot_id            = var.snapshot_id
  kms_encrypted          = var.kms_encrypted
  kms_key                = var.kms_key
  tags                   = var.tags
}