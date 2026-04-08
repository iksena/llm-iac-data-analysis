output "arn" {
  description = "ARN of the AppConfig Application."
  value       = aws_appconfig_application.this.arn
}

output "id" {
  description = "AppConfig application ID."
  value       = aws_appconfig_application.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_appconfig_application.this.tags_all
}