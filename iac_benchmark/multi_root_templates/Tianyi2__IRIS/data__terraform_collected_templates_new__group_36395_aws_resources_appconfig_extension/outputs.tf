output "arn" {
  description = "ARN of the AppConfig Extension."
  value       = aws_appconfig_extension.this.arn
}

output "id" {
  description = "AppConfig Extension ID."
  value       = aws_appconfig_extension.this.id
}

output "version" {
  description = "The version number for the extension."
  value       = aws_appconfig_extension.this.version
}