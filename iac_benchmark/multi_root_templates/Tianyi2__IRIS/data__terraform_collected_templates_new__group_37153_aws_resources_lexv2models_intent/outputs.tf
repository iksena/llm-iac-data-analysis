output "creation_date_time" {
  description = "Timestamp of the date and time that the intent was created."
  value       = aws_lexv2models_intent.this.creation_date_time
}

output "id" {
  description = "Composite identifier of intent_id:bot_id:bot_version:locale_id."
  value       = aws_lexv2models_intent.this.id
}

output "intent_id" {
  description = "Unique identifier for the intent."
  value       = aws_lexv2models_intent.this.intent_id
}

output "last_updated_date_time" {
  description = "Timestamp of the last time that the intent was modified."
  value       = aws_lexv2models_intent.this.last_updated_date_time
}