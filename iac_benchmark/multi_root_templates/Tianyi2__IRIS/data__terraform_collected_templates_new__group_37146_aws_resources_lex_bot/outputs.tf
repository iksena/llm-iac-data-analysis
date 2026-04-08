output "checksum" {
  description = "Checksum identifying the version of the bot that was created"
  value       = aws_lex_bot.this.checksum
}

output "created_date" {
  description = "The date when the bot version was created"
  value       = aws_lex_bot.this.created_date
}

output "failure_reason" {
  description = "If status is FAILED, Amazon Lex provides the reason that it failed to build the bot"
  value       = aws_lex_bot.this.failure_reason
}

output "last_updated_date" {
  description = "The date when the $LATEST version of this bot was updated"
  value       = aws_lex_bot.this.last_updated_date
}

output "status" {
  description = "The status of the bot"
  value       = aws_lex_bot.this.status
}

output "version" {
  description = "The version of the bot"
  value       = aws_lex_bot.this.version
}