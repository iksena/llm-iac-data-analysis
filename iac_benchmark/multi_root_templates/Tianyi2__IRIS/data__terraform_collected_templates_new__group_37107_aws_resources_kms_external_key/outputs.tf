output "arn" {
  description = "The Amazon Resource Name (ARN) of the key."
  value       = aws_kms_external_key.this.arn
}

output "expiration_model" {
  description = "Whether the key material expires. Empty when pending key material import, otherwise KEY_MATERIAL_EXPIRES or KEY_MATERIAL_DOES_NOT_EXPIRE."
  value       = aws_kms_external_key.this.expiration_model
}

output "id" {
  description = "The unique identifier for the key."
  value       = aws_kms_external_key.this.id
}

output "key_state" {
  description = "The state of the CMK."
  value       = aws_kms_external_key.this.key_state
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_kms_external_key.this.tags_all
}