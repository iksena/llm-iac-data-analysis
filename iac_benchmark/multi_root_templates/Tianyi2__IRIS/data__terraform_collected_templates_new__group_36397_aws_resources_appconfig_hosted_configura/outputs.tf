output "arn" {
  description = "ARN of the AppConfig hosted configuration version."
  value       = aws_appconfig_hosted_configuration_version.this.arn
}

output "id" {
  description = "AppConfig application ID, configuration profile ID, and version number separated by a slash (/)."
  value       = aws_appconfig_hosted_configuration_version.this.id
}

output "version_number" {
  description = "Version number of the hosted configuration."
  value       = aws_appconfig_hosted_configuration_version.this.version_number
}