output "alias_name" {
  description = "Name of the Key Alias."
  value       = aws_paymentcryptography_key_alias.this.alias_name
}

output "key_arn" {
  description = "ARN of the key."
  value       = aws_paymentcryptography_key_alias.this.key_arn
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_paymentcryptography_key_alias.this.region
}