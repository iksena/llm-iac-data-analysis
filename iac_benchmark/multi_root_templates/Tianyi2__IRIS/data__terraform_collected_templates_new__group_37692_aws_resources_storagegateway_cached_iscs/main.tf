resource "aws_storagegateway_cached_iscsi_volume" "this" {
  region               = var.region
  gateway_arn          = var.gateway_arn
  network_interface_id = var.network_interface_id
  target_name          = var.target_name
  volume_size_in_bytes = var.volume_size_in_bytes
  snapshot_id          = var.snapshot_id
  source_volume_arn    = var.source_volume_arn
  kms_encrypted        = var.kms_encrypted
  kms_key              = var.kms_key
  tags                 = var.tags
}