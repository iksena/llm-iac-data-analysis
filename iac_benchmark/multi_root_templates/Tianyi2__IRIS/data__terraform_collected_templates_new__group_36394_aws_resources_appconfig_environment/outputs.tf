output "arn" {
  description = "ARN of the AppConfig Environment."
  value       = aws_appconfig_environment.this.arn
}

output "id" {
  description = "AppConfig environment ID and application ID separated by a colon (:). Deprecated."
  value       = aws_appconfig_environment.this.id
}

output "environment_id" {
  description = "AppConfig environment ID."
  value       = aws_appconfig_environment.this.environment_id
}

output "state" {
  description = "State of the environment. Possible values are READY_FOR_DEPLOYMENT, DEPLOYING, ROLLING_BACK or ROLLED_BACK."
  value       = aws_appconfig_environment.this.state
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_appconfig_environment.this.tags_all
}