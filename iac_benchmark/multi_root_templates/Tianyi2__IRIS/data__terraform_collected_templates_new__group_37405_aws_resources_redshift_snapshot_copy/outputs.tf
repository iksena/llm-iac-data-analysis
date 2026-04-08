output "id" {
  description = "Identifier of the source cluster"
  value       = aws_redshift_snapshot_copy.this.id
}

output "cluster_identifier" {
  description = "Identifier of the source cluster"
  value       = aws_redshift_snapshot_copy.this.cluster_identifier
}

output "destination_region" {
  description = "AWS Region to copy snapshots to"
  value       = aws_redshift_snapshot_copy.this.destination_region
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_redshift_snapshot_copy.this.region
}

output "manual_snapshot_retention_period" {
  description = "Number of days to retain newly copied snapshots in the destination AWS Region"
  value       = aws_redshift_snapshot_copy.this.manual_snapshot_retention_period
}

output "retention_period" {
  description = "Number of days to retain automated snapshots in the destination region"
  value       = aws_redshift_snapshot_copy.this.retention_period
}

output "snapshot_copy_grant_name" {
  description = "Name of the snapshot copy grant used for KMS-encrypted cluster snapshots"
  value       = aws_redshift_snapshot_copy.this.snapshot_copy_grant_name
}