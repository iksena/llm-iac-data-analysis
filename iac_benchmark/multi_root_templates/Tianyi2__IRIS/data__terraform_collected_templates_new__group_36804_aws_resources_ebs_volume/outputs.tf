output "arn" {
  description = "Volume ARN (e.g., arn:aws:ec2:us-east-1:123456789012:volume/vol-59fcb34e)."
  value       = aws_ebs_volume.this.arn
}

output "create_time" {
  description = "Timestamp when volume creation was initiated."
  value       = aws_ebs_volume.this.create_time
}

output "id" {
  description = "Volume ID (e.g., vol-59fcb34e)."
  value       = aws_ebs_volume.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ebs_volume.this.tags_all
}

# Additional outputs for convenience - returning input arguments
output "availability_zone" {
  description = "Availability zone where the EBS volume exists."
  value       = aws_ebs_volume.this.availability_zone
}

output "encrypted" {
  description = "Whether the disk is encrypted."
  value       = aws_ebs_volume.this.encrypted
}

output "final_snapshot" {
  description = "Whether snapshot will be created before volume deletion."
  value       = aws_ebs_volume.this.final_snapshot
}

output "iops" {
  description = "Amount of IOPS provisioned for the disk."
  value       = aws_ebs_volume.this.iops
}

output "kms_key_id" {
  description = "ARN for the KMS encryption key."
  value       = aws_ebs_volume.this.kms_key_id
}

output "multi_attach_enabled" {
  description = "Whether Amazon EBS Multi-Attach is enabled."
  value       = aws_ebs_volume.this.multi_attach_enabled
}

output "outpost_arn" {
  description = "Amazon Resource Name (ARN) of the Outpost."
  value       = aws_ebs_volume.this.outpost_arn
}

output "size" {
  description = "Size of the drive in GiBs."
  value       = aws_ebs_volume.this.size
}

output "snapshot_id" {
  description = "A snapshot the EBS volume is based off of."
  value       = aws_ebs_volume.this.snapshot_id
}

output "tags" {
  description = "A map of tags assigned to the resource."
  value       = aws_ebs_volume.this.tags
}

output "throughput" {
  description = "Throughput that the volume supports, in MiB/s."
  value       = aws_ebs_volume.this.throughput
}

output "type" {
  description = "Type of EBS volume."
  value       = aws_ebs_volume.this.type
}

output "volume_initialization_rate" {
  description = "EBS provisioned rate for volume initialization, in MiB/s."
  value       = aws_ebs_volume.this.volume_initialization_rate
}