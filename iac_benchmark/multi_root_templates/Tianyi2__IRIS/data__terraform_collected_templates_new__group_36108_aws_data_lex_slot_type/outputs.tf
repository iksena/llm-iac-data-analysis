output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_lex_slot_type.this.region
}

output "name" {
  description = "Name of the slot type"
  value       = data.aws_lex_slot_type.this.name
}

output "version" {
  description = "Version of the slot type"
  value       = data.aws_lex_slot_type.this.version
}

output "checksum" {
  description = "Checksum identifying the version of the slot type that was created"
  value       = data.aws_lex_slot_type.this.checksum
}

output "created_date" {
  description = "Date when the slot type version was created"
  value       = data.aws_lex_slot_type.this.created_date
}

output "description" {
  description = "Description of the slot type"
  value       = data.aws_lex_slot_type.this.description
}

output "enumeration_value" {
  description = "Set of EnumerationValue objects that defines the values that the slot type can take"
  value       = data.aws_lex_slot_type.this.enumeration_value
}

output "last_updated_date" {
  description = "Date when the $LATEST version of this slot type was updated"
  value       = data.aws_lex_slot_type.this.last_updated_date
}

output "value_selection_strategy" {
  description = "Determines the slot resolution strategy that Amazon Lex uses to return slot type values"
  value       = data.aws_lex_slot_type.this.value_selection_strategy
}