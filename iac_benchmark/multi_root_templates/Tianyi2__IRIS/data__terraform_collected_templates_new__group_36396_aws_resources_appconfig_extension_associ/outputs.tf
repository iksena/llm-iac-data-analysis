output "arn" {
  description = "ARN of the AppConfig Extension Association."
  value       = aws_appconfig_extension_association.this.arn
}

output "id" {
  description = "AppConfig Extension Association ID."
  value       = aws_appconfig_extension_association.this.id
}

output "extension_version" {
  description = "The version number for the extension defined in the association."
  value       = aws_appconfig_extension_association.this.extension_version
}