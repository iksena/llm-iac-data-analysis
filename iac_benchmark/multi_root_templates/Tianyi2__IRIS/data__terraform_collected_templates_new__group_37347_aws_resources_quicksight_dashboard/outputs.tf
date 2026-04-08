output "arn" {
  description = "ARN of the dashboard."
  value       = aws_quicksight_dashboard.this.arn
}

output "created_time" {
  description = "The time that the dashboard was created."
  value       = aws_quicksight_dashboard.this.created_time
}

output "id" {
  description = "A comma-delimited string joining AWS account ID and dashboard ID."
  value       = aws_quicksight_dashboard.this.id
}

output "last_updated_time" {
  description = "The time that the dashboard was last updated."
  value       = aws_quicksight_dashboard.this.last_updated_time
}

output "source_entity_arn" {
  description = "Amazon Resource Name (ARN) of a template that was used to create this dashboard."
  value       = aws_quicksight_dashboard.this.source_entity_arn
}

output "status" {
  description = "The dashboard creation status."
  value       = aws_quicksight_dashboard.this.status
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_quicksight_dashboard.this.tags_all
}

output "version_number" {
  description = "The version number of the dashboard version."
  value       = aws_quicksight_dashboard.this.version_number
}