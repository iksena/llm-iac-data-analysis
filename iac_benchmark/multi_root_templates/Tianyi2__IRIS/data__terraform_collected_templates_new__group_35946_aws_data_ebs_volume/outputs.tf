output "arn" {
  description = "Volume ARN (e.g., arn:aws:ec2:us-east-1:123456789012:volume/vol-59fcb34e)."
  value       = data.aws_ebs_volume.this.arn
}

output "availability_zone" {
  description = "Availability zone where the EBS volume exists."
  value       = data.aws_ebs_volume.this.availability_zone
}

output "create_time" {
  description = "Timestamp when volume creation was initiated."
  value       = data.aws_ebs_volume.this.create_time
}

output "encrypted" {
  description = "Whether the disk is encrypted."
  value       = data.aws_ebs_volume.this.encrypted
}

output "id" {
  description = "Volume ID (e.g., vol-59fcb34e)."
  value       = data.aws_ebs_volume.this.id
}

output "iops" {
  description = "Amount of IOPS for the disk."
  value       = data.aws_ebs_volume.this.iops
}

output "kms_key_id" {
  description = "ARN for the KMS encryption key."
  value       = data.aws_ebs_volume.this.kms_key_id
}

output "multi_attach_enabled" {
  description = "Specifies whether Amazon EBS Multi-Attach is enabled."
  value       = data.aws_ebs_volume.this.multi_attach_enabled
}

output "outpost_arn" {
  description = "ARN of the Outpost."
  value       = data.aws_ebs_volume.this.outpost_arn
}

output "size" {
  description = "Size of the drive in GiBs."
  value       = data.aws_ebs_volume.this.size
}

output "snapshot_id" {
  description = "Snapshot_id the EBS volume is based off."
  value       = data.aws_ebs_volume.this.snapshot_id
}

output "tags" {
  description = "Map of tags for the resource."
  value       = data.aws_ebs_volume.this.tags
}

output "throughput" {
  description = "Throughput that the volume supports, in MiB/s."
  value       = data.aws_ebs_volume.this.throughput
}

output "volume_id" {
  description = "Volume ID (e.g., vol-59fcb34e)."
  value       = data.aws_ebs_volume.this.volume_id
}

output "volume_type" {
  description = "Type of EBS volume."
  value       = data.aws_ebs_volume.this.volume_type
}

output "volume_initialization_rate" {
  description = "EBS provisioned rate for volume initialization, in MiB/s, at which to download the snapshot blocks from Amazon S3 to the volume."
  value       = data.aws_ebs_volume.this.volume_initialization_rate
}