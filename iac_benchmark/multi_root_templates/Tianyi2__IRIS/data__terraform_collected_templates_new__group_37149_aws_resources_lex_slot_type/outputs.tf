output "checksum" {
  description = "Checksum identifying the version of the slot type that was created. The checksum is not included as an argument because the resource will add it automatically when updating the slot type."
  value       = aws_lex_slot_type.this.checksum
}

output "created_date" {
  description = "The date when the slot type version was created."
  value       = aws_lex_slot_type.this.created_date
}

output "last_updated_date" {
  description = "The date when the $LATEST version of this slot type was updated."
  value       = aws_lex_slot_type.this.last_updated_date
}

output "version" {
  description = "The version of the slot type."
  value       = aws_lex_slot_type.this.version
}

output "name" {
  description = "The name of the slot type."
  value       = aws_lex_slot_type.this.name
}

output "enumeration_value" {
  description = "The enumeration values for the slot type."
  value       = aws_lex_slot_type.this.enumeration_value
}

output "create_version" {
  description = "Whether a new slot type version is created."
  value       = aws_lex_slot_type.this.create_version
}

output "description" {
  description = "The description of the slot type."
  value       = aws_lex_slot_type.this.description
}

output "value_selection_strategy" {
  description = "The slot resolution strategy."
  value       = aws_lex_slot_type.this.value_selection_strategy
}