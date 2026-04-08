output "id" {
  description = "Unique identifier for a particular bot."
  value       = aws_lexv2models_bot.this.id
}

output "name" {
  description = "Name of the bot."
  value       = aws_lexv2models_bot.this.name
}

output "description" {
  description = "Description of the bot."
  value       = aws_lexv2models_bot.this.description
}

output "data_privacy" {
  description = "Information on additional privacy protections Amazon Lex uses with the bot's data."
  value       = aws_lexv2models_bot.this.data_privacy
}

output "idle_session_ttl_in_seconds" {
  description = "Time, in seconds, that Amazon Lex keeps information about a user's conversation with the bot."
  value       = aws_lexv2models_bot.this.idle_session_ttl_in_seconds
}

output "role_arn" {
  description = "ARN of the IAM role that has permission to access the bot."
  value       = aws_lexv2models_bot.this.role_arn
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_lexv2models_bot.this.region
}

output "members" {
  description = "List of bot members in the network."
  value       = aws_lexv2models_bot.this.members
}

output "tags" {
  description = "Tags assigned to the bot."
  value       = aws_lexv2models_bot.this.tags
}

output "type" {
  description = "Type of the bot."
  value       = aws_lexv2models_bot.this.type
}

output "test_bot_alias_tags" {
  description = "Tags assigned to the test alias for the bot."
  value       = aws_lexv2models_bot.this.test_bot_alias_tags
}