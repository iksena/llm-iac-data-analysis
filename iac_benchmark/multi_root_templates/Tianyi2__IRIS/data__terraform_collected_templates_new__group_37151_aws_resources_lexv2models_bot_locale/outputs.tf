output "id" {
  description = "Comma-delimited string joining locale_id, bot_id, and bot_version."
  value       = aws_lexv2models_bot_locale.this.id
}

output "name" {
  description = "Specified locale name."
  value       = aws_lexv2models_bot_locale.this.name
}