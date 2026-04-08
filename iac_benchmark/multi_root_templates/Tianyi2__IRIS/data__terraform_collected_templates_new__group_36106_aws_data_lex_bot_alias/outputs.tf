output "arn" {
  value       = data.aws_lex_bot_alias.this.arn
  description = "ARN of the bot alias."
}

output "bot_name" {
  value       = data.aws_lex_bot_alias.this.bot_name
  description = "Name of the bot."
}

output "bot_version" {
  value       = data.aws_lex_bot_alias.this.bot_version
  description = "Version of the bot that the alias points to."
}

output "checksum" {
  value       = data.aws_lex_bot_alias.this.checksum
  description = "Checksum of the bot alias."
}

output "created_date" {
  value       = data.aws_lex_bot_alias.this.created_date
  description = "Date that the bot alias was created."
}

output "description" {
  value       = data.aws_lex_bot_alias.this.description
  description = "Description of the alias."
}

output "last_updated_date" {
  value       = data.aws_lex_bot_alias.this.last_updated_date
  description = "Date that the bot alias was updated. When you create a resource, the creation date and the last updated date are the same."
}

output "name" {
  value       = data.aws_lex_bot_alias.this.name
  description = "Name of the alias. The name is not case sensitive."
}

output "region" {
  value       = data.aws_lex_bot_alias.this.region
  description = "Region where this resource is managed."
}