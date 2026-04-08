output "arn" {
  description = "Amazon Resource Name (ARN) of the EBS Snapshot"
  value       = aws_ebs_snapshot_import.this.arn
}

output "id" {
  description = "The snapshot ID (e.g., snap-59fcb34e)"
  value       = aws_ebs_snapshot_import.this.id
}

output "owner_id" {
  description = "The AWS account ID of the EBS snapshot owner"
  value       = aws_ebs_snapshot_import.this.owner_id
}

output "owner_alias" {
  description = "Value from an Amazon-maintained list (amazon, aws-marketplace, microsoft) of snapshot owners"
  value       = aws_ebs_snapshot_import.this.owner_alias
}

output "volume_size" {
  description = "The size of the drive in GiBs"
  value       = aws_ebs_snapshot_import.this.volume_size
}

output "data_encryption_key_id" {
  description = "The data encryption key identifier for the snapshot"
  value       = aws_ebs_snapshot_import.this.data_encryption_key_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_ebs_snapshot_import.this.tags_all
}