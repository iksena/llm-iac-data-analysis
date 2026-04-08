output "environment_ids" {
  description = "Set of Environment IDs associated with this AppConfig Application"
  value       = data.aws_appconfig_environments.this.environment_ids
}

output "application_id" {
  description = "ID of the AppConfig Application"
  value       = data.aws_appconfig_environments.this.application_id
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_appconfig_environments.this.region
}