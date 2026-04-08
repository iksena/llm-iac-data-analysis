output "arn" {
  description = "ARN of the AppConfig Configuration Profile."
  value       = aws_appconfig_configuration_profile.this.arn
}

output "configuration_profile_id" {
  description = "The configuration profile ID."
  value       = aws_appconfig_configuration_profile.this.configuration_profile_id
}

output "id" {
  description = "AppConfig configuration profile ID and application ID separated by a colon (:)."
  value       = aws_appconfig_configuration_profile.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_appconfig_configuration_profile.this.tags_all
}