output "arn" {
  description = "The Amazon Resource Name (ARN) of the key alias."
  value       = aws_kms_alias.this.arn
}

output "target_key_arn" {
  description = "The Amazon Resource Name (ARN) of the target key identifier."
  value       = aws_kms_alias.this.target_key_arn
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_kms_alias.this.region
}

output "name" {
  description = "The display name of the alias."
  value       = aws_kms_alias.this.name
}

output "name_prefix" {
  description = "The unique alias prefix."
  value       = aws_kms_alias.this.name_prefix
}

output "target_key_id" {
  description = "Identifier for the key for which the alias is for."
  value       = aws_kms_alias.this.target_key_id
}