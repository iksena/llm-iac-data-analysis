output "id" {
  description = "The application snapshot identifier."
  value       = aws_kinesisanalyticsv2_application_snapshot.this.id
}

output "application_version_id" {
  description = "The current application version ID when the snapshot was created."
  value       = aws_kinesisanalyticsv2_application_snapshot.this.application_version_id
}

output "snapshot_creation_timestamp" {
  description = "The timestamp of the application snapshot."
  value       = aws_kinesisanalyticsv2_application_snapshot.this.snapshot_creation_timestamp
}