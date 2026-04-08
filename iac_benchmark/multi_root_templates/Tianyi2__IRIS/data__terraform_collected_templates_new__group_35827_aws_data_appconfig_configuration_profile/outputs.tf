output "arn" {
  description = "ARN of the Configuration Profile."
  value       = data.aws_appconfig_configuration_profile.this.arn
}

output "description" {
  description = "Description of the Configuration Profile."
  value       = data.aws_appconfig_configuration_profile.this.description
}

output "id" {
  description = "AppConfig Configuration Profile ID and Application ID separated by a colon (:)."
  value       = data.aws_appconfig_configuration_profile.this.id
}

output "location_uri" {
  description = "Location URI of the Configuration Profile."
  value       = data.aws_appconfig_configuration_profile.this.location_uri
}

output "name" {
  description = "Name of the Configuration Profile."
  value       = data.aws_appconfig_configuration_profile.this.name
}

output "retrieval_role_arn" {
  description = "ARN of an IAM role with permission to access the configuration at the specified location_uri."
  value       = data.aws_appconfig_configuration_profile.this.retrieval_role_arn
}

output "tags" {
  description = "Map of tags for the resource."
  value       = data.aws_appconfig_configuration_profile.this.tags
}

output "validator" {
  description = "Nested list of methods for validating the configuration."
  value       = data.aws_appconfig_configuration_profile.this.validator
}