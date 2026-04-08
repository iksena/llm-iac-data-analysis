output "id" {
  description = "Comma-delimited string concatenating bot_id, bot_version, locale_id, and slot_type_id"
  value       = aws_lexv2models_slot_type.this.id
}

output "slot_type_id" {
  description = "Unique identifier for the slot type"
  value       = aws_lexv2models_slot_type.this.slot_type_id
}

output "bot_id" {
  description = "Identifier of the bot associated with this slot type"
  value       = aws_lexv2models_slot_type.this.bot_id
}

output "bot_version" {
  description = "Version of the bot associated with this slot type"
  value       = aws_lexv2models_slot_type.this.bot_version
}

output "locale_id" {
  description = "Identifier of the language and locale where this slot type is used"
  value       = aws_lexv2models_slot_type.this.locale_id
}

output "name" {
  description = "Name of the slot type"
  value       = aws_lexv2models_slot_type.this.name
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_lexv2models_slot_type.this.region
}

output "description" {
  description = "Description of the slot type"
  value       = aws_lexv2models_slot_type.this.description
}

output "composite_slot_type_setting" {
  description = "Specifications for a composite slot type"
  value       = aws_lexv2models_slot_type.this.composite_slot_type_setting
}

output "external_source_setting" {
  description = "Type of external information used to create the slot type"
  value       = aws_lexv2models_slot_type.this.external_source_setting
}

output "parent_slot_type_signature" {
  description = "Built-in slot type used as a parent of this slot type"
  value       = aws_lexv2models_slot_type.this.parent_slot_type_signature
}

output "slot_type_values" {
  description = "List of SlotTypeValue objects that defines the values that the slot type can take"
  value       = aws_lexv2models_slot_type.this.slot_type_values
}

output "value_selection_setting" {
  description = "Strategy that Amazon Lex uses to select a value from the list of possible values"
  value       = aws_lexv2models_slot_type.this.value_selection_setting
}