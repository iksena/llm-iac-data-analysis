output "arn" {
  description = "Amazon Resource Name (ARN) of the Redshift Snapshot Schedule."
  value       = aws_redshift_snapshot_schedule.this.arn
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_redshift_snapshot_schedule.this.region
}

output "identifier" {
  description = "The snapshot schedule identifier."
  value       = aws_redshift_snapshot_schedule.this.identifier
}

output "identifier_prefix" {
  description = "The identifier prefix used for creating unique identifier."
  value       = aws_redshift_snapshot_schedule.this.identifier_prefix
}

output "description" {
  description = "The description of the snapshot schedule."
  value       = aws_redshift_snapshot_schedule.this.description
}

output "definitions" {
  description = "The definition of the snapshot schedule."
  value       = aws_redshift_snapshot_schedule.this.definitions
}

output "force_destroy" {
  description = "Whether to destroy all associated clusters with this snapshot schedule on deletion."
  value       = aws_redshift_snapshot_schedule.this.force_destroy
}

output "tags" {
  description = "A map of tags assigned to the resource."
  value       = aws_redshift_snapshot_schedule.this.tags
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_redshift_snapshot_schedule.this.tags_all
}