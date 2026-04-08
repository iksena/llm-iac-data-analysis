output "arn" {
  description = "Amazon Resource Name (ARN) of snapshot copy grant"
  value       = aws_redshift_snapshot_copy_grant.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_redshift_snapshot_copy_grant.this.tags_all
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_redshift_snapshot_copy_grant.this.region
}

output "snapshot_copy_grant_name" {
  description = "The friendly name for identifying the grant"
  value       = aws_redshift_snapshot_copy_grant.this.snapshot_copy_grant_name
}

output "kms_key_id" {
  description = "The unique identifier for the customer master key (CMK) that the grant applies to"
  value       = aws_redshift_snapshot_copy_grant.this.kms_key_id
}