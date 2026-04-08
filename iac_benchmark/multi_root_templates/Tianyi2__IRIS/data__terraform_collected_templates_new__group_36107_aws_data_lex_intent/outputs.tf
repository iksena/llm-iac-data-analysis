output "arn" {
  description = "ARN of the Lex intent."
  value       = data.aws_lex_intent.this.arn
}

output "checksum" {
  description = "Checksum identifying the version of the intent that was created."
  value       = data.aws_lex_intent.this.checksum
}

output "created_date" {
  description = "Date when the intent version was created."
  value       = data.aws_lex_intent.this.created_date
}

output "description" {
  description = "Description of the intent."
  value       = data.aws_lex_intent.this.description
}

output "last_updated_date" {
  description = "Date when the $LATEST version of this intent was updated."
  value       = data.aws_lex_intent.this.last_updated_date
}

output "name" {
  description = "Name of the intent, not case sensitive."
  value       = data.aws_lex_intent.this.name
}

output "parent_intent_signature" {
  description = "A unique identifier for the built-in intent to base this intent on."
  value       = data.aws_lex_intent.this.parent_intent_signature
}

output "version" {
  description = "Version of the bot."
  value       = data.aws_lex_intent.this.version
}