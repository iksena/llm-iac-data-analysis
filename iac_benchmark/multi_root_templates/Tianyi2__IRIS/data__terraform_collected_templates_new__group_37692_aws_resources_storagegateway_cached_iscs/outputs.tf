output "arn" {
  description = "Volume Amazon Resource Name (ARN), e.g., arn:aws:storagegateway:us-east-1:123456789012:gateway/sgw-12345678/volume/vol-12345678."
  value       = aws_storagegateway_cached_iscsi_volume.this.arn
}

output "chap_enabled" {
  description = "Whether mutual CHAP is enabled for the iSCSI target."
  value       = aws_storagegateway_cached_iscsi_volume.this.chap_enabled
}

output "id" {
  description = "Volume Amazon Resource Name (ARN), e.g., arn:aws:storagegateway:us-east-1:123456789012:gateway/sgw-12345678/volume/vol-12345678."
  value       = aws_storagegateway_cached_iscsi_volume.this.id
}

output "lun_number" {
  description = "Logical disk number."
  value       = aws_storagegateway_cached_iscsi_volume.this.lun_number
}

output "network_interface_port" {
  description = "The port used to communicate with iSCSI targets."
  value       = aws_storagegateway_cached_iscsi_volume.this.network_interface_port
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_storagegateway_cached_iscsi_volume.this.tags_all
}

output "target_arn" {
  description = "Target Amazon Resource Name (ARN), e.g., arn:aws:storagegateway:us-east-1:123456789012:gateway/sgw-12345678/target/iqn.1997-05.com.amazon:TargetName."
  value       = aws_storagegateway_cached_iscsi_volume.this.target_arn
}

output "volume_arn" {
  description = "Volume Amazon Resource Name (ARN), e.g., arn:aws:storagegateway:us-east-1:123456789012:gateway/sgw-12345678/volume/vol-12345678."
  value       = aws_storagegateway_cached_iscsi_volume.this.volume_arn
}

output "volume_id" {
  description = "Volume ID, e.g., vol-12345678."
  value       = aws_storagegateway_cached_iscsi_volume.this.volume_id
}