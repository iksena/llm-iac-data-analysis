output "arn" {
  description = "The ARN of the bot alias."
  value       = aws_lex_bot_alias.this.arn
}

output "checksum" {
  description = "Checksum of the bot alias."
  value       = aws_lex_bot_alias.this.checksum
}

output "created_date" {
  description = "The date that the bot alias was created."
  value       = aws_lex_bot_alias.this.created_date
}

output "last_updated_date" {
  description = "The date that the bot alias was updated. When you create a resource, the creation date and the last updated date are the same."
  value       = aws_lex_bot_alias.this.last_updated_date
}

output "resource_prefix" {
  description = "The prefix of the S3 object key for AUDIO logs or the log stream name for TEXT logs."
  value       = try(tolist(aws_lex_bot_alias.this.conversation_logs[0].log_settings)[0].resource_prefix, null)
}