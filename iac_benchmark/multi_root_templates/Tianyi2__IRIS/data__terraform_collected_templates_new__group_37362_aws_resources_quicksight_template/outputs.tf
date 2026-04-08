output "arn" {
  description = "ARN of the template."
  value       = aws_quicksight_template.this.arn
}

output "created_time" {
  description = "The time that the template was created."
  value       = aws_quicksight_template.this.created_time
}

output "id" {
  description = "A comma-delimited string joining AWS account ID and template ID."
  value       = aws_quicksight_template.this.id
}

output "last_updated_time" {
  description = "The time that the template was last updated."
  value       = aws_quicksight_template.this.last_updated_time
}

output "source_entity_arn" {
  description = "Amazon Resource Name (ARN) of an analysis or template that was used to create this template."
  value       = aws_quicksight_template.this.source_entity_arn
}

output "status" {
  description = "The template creation status."
  value       = aws_quicksight_template.this.status
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_quicksight_template.this.tags_all
}

output "version_number" {
  description = "The version number of the template version."
  value       = aws_quicksight_template.this.version_number
}