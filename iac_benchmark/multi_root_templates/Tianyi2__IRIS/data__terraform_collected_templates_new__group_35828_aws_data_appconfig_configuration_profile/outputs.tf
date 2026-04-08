output "configuration_profile_ids" {
  description = "Set of Configuration Profile IDs associated with the AppConfig Application"
  value       = data.aws_appconfig_configuration_profiles.this.configuration_profile_ids
}

output "application_id" {
  description = "ID of the AppConfig Application"
  value       = data.aws_appconfig_configuration_profiles.this.application_id
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_appconfig_configuration_profiles.this.region
}