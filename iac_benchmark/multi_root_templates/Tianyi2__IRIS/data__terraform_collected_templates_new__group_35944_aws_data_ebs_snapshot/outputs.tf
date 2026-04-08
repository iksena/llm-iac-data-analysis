output "arn" {
  description = "ARN of the EBS Snapshot."
  value       = data.aws_ebs_snapshot.this.arn
}

output "id" {
  description = "Snapshot ID (e.g., snap-59fcb34e)."
  value       = data.aws_ebs_snapshot.this.id
}

output "snapshot_id" {
  description = "Snapshot ID (e.g., snap-59fcb34e)."
  value       = data.aws_ebs_snapshot.this.snapshot_id
}

output "description" {
  description = "Description for the snapshot."
  value       = data.aws_ebs_snapshot.this.description
}

output "owner_id" {
  description = "AWS account ID of the EBS snapshot owner."
  value       = data.aws_ebs_snapshot.this.owner_id
}

output "owner_alias" {
  description = "Value from an Amazon-maintained list (amazon, aws-marketplace, microsoft) of snapshot owners."
  value       = data.aws_ebs_snapshot.this.owner_alias
}

output "volume_id" {
  description = "Volume ID (e.g., vol-59fcb34e)."
  value       = data.aws_ebs_snapshot.this.volume_id
}

output "encrypted" {
  description = "Whether the snapshot is encrypted."
  value       = data.aws_ebs_snapshot.this.encrypted
}

output "volume_size" {
  description = "Size of the drive in GiBs."
  value       = data.aws_ebs_snapshot.this.volume_size
}

output "kms_key_id" {
  description = "ARN for the KMS encryption key."
  value       = data.aws_ebs_snapshot.this.kms_key_id
}

output "data_encryption_key_id" {
  description = "The data encryption key identifier for the snapshot."
  value       = data.aws_ebs_snapshot.this.data_encryption_key_id
}

output "start_time" {
  description = "Time stamp when the snapshot was initiated."
  value       = data.aws_ebs_snapshot.this.start_time
}

output "state" {
  description = "Snapshot state."
  value       = data.aws_ebs_snapshot.this.state
}

output "storage_tier" {
  description = "Storage tier in which the snapshot is stored."
  value       = data.aws_ebs_snapshot.this.storage_tier
}

output "outpost_arn" {
  description = "ARN of the Outpost on which the snapshot is stored."
  value       = data.aws_ebs_snapshot.this.outpost_arn
}

output "tags" {
  description = "Map of tags for the resource."
  value       = data.aws_ebs_snapshot.this.tags
}