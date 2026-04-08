output "arn" {
  description = "ARN of the theme."
  value       = aws_quicksight_theme.this.arn
}

output "created_time" {
  description = "The time that the theme was created."
  value       = aws_quicksight_theme.this.created_time
}

output "id" {
  description = "A comma-delimited string joining AWS account ID and theme ID."
  value       = aws_quicksight_theme.this.id
}

output "last_updated_time" {
  description = "The time that the theme was last updated."
  value       = aws_quicksight_theme.this.last_updated_time
}

output "status" {
  description = "The theme creation status."
  value       = aws_quicksight_theme.this.status
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_quicksight_theme.this.tags_all
}

output "version_number" {
  description = "The version number of the theme version."
  value       = aws_quicksight_theme.this.version_number
}