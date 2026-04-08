output "arn" {
  description = "The ARN of the Lex intent."
  value       = aws_lex_intent.this.arn
}

output "checksum" {
  description = "Checksum identifying the version of the intent that was created. The checksum is not included as an argument because the resource will add it automatically when updating the intent."
  value       = aws_lex_intent.this.checksum
}

output "created_date" {
  description = "The date when the intent version was created."
  value       = aws_lex_intent.this.created_date
}

output "last_updated_date" {
  description = "The date when the $LATEST version of this intent was updated."
  value       = aws_lex_intent.this.last_updated_date
}

output "version" {
  description = "The version of the bot."
  value       = aws_lex_intent.this.version
}