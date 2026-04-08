output "id" {
  description = "AppConfig deployment strategy ID."
  value       = aws_appconfig_deployment_strategy.this.id
}

output "arn" {
  description = "ARN of the AppConfig Deployment Strategy."
  value       = aws_appconfig_deployment_strategy.this.arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_appconfig_deployment_strategy.this.tags_all
}