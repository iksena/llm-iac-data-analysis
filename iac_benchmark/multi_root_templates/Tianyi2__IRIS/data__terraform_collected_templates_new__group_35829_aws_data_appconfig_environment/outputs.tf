output "arn" {
  description = "ARN of the environment."
  value       = data.aws_appconfig_environment.this.arn
}

output "name" {
  description = "Name of the environment."
  value       = data.aws_appconfig_environment.this.name
}

output "description" {
  description = "Name of the environment."
  value       = data.aws_appconfig_environment.this.description
}

output "monitor" {
  description = "Set of Amazon CloudWatch alarms to monitor during the deployment process."
  value       = data.aws_appconfig_environment.this.monitor
}

output "state" {
  description = "State of the environment. Possible values are READY_FOR_DEPLOYMENT, DEPLOYING, ROLLING_BACK or ROLLED_BACK."
  value       = data.aws_appconfig_environment.this.state
}

output "tags" {
  description = "Map of tags for the resource."
  value       = data.aws_appconfig_environment.this.tags
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_appconfig_environment.this.region
}

output "application_id" {
  description = "ID of the AppConfig Application to which this Environment belongs."
  value       = data.aws_appconfig_environment.this.application_id
}

output "environment_id" {
  description = "ID of the AppConfig Environment."
  value       = data.aws_appconfig_environment.this.environment_id
}