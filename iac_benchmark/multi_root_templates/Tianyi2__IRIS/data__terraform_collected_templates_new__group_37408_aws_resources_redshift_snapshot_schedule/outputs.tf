output "cluster_identifier" {
  description = "The cluster identifier."
  value       = aws_redshift_snapshot_schedule_association.this.cluster_identifier
}

output "schedule_identifier" {
  description = "The snapshot schedule identifier."
  value       = aws_redshift_snapshot_schedule_association.this.schedule_identifier
}

output "region" {
  description = "The region where the resource is managed."
  value       = aws_redshift_snapshot_schedule_association.this.region
}