output "id" {
  description = "A comma-delimited string concatenating bot_id, bot_version, intent_id, locale_id, and slot_id"
  value       = aws_lexv2models_slot.this.id
}

output "slot_id" {
  description = "Unique identifier associated with the slot"
  value       = aws_lexv2models_slot.this.slot_id
}