output "arn" {
  description = "Amazon Resource Name(ARN) of the key alias"
  value       = data.aws_kms_alias.this.arn
}

output "id" {
  description = "Amazon Resource Name(ARN) of the key alias"
  value       = data.aws_kms_alias.this.id
}

output "target_key_id" {
  description = "Key identifier pointed to by the alias"
  value       = data.aws_kms_alias.this.target_key_id
}

output "target_key_arn" {
  description = "ARN pointed to by the alias"
  value       = data.aws_kms_alias.this.target_key_arn
}

output "name" {
  description = "Name of the alias"
  value       = data.aws_kms_alias.this.name
}

