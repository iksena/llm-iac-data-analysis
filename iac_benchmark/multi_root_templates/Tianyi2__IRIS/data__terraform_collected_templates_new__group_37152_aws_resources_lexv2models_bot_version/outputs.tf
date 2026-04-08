output "bot_version" {
  description = "Version number assigned to the version."
  value       = aws_lexv2models_bot_version.this.bot_version
}

output "id" {
  description = "A comma-delimited string concatenating bot_id and bot_version."
  value       = aws_lexv2models_bot_version.this.id
}

output "bot_id" {
  description = "Identifier of the bot to create the version for."
  value       = aws_lexv2models_bot_version.this.bot_id
}

output "locale_specification" {
  description = "Specifies the locales that Amazon Lex adds to this version."
  value       = aws_lexv2models_bot_version.this.locale_specification
}

output "description" {
  description = "A description of the version."
  value       = aws_lexv2models_bot_version.this.description
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_lexv2models_bot_version.this.region
}