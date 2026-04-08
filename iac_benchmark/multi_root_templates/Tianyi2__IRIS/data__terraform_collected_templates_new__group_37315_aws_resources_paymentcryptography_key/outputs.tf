output "arn" {
  description = "ARN of the key"
  value       = aws_paymentcryptography_key.this.arn
}

output "exportable" {
  description = "Whether the key is exportable from the service"
  value       = aws_paymentcryptography_key.this.exportable
}

output "enabled" {
  description = "Whether the key is enabled"
  value       = aws_paymentcryptography_key.this.enabled
}

output "key_check_value" {
  description = "Key check value (KCV) is used to check if all parties holding a given key have the same key or to detect that a key has changed"
  value       = aws_paymentcryptography_key.this.key_check_value
}

output "key_check_value_algorithm" {
  description = "Algorithm that AWS Payment Cryptography uses to calculate the key check value (KCV)"
  value       = aws_paymentcryptography_key.this.key_check_value_algorithm
}

output "key_origin" {
  description = "Source of the key material"
  value       = aws_paymentcryptography_key.this.key_origin
}

output "key_state" {
  description = "State of key that is being created or deleted"
  value       = aws_paymentcryptography_key.this.key_state
}

output "key_attributes" {
  description = "Role of the key, the algorithm it supports, and the cryptographic operations allowed with the key"
  value       = aws_paymentcryptography_key.this.key_attributes
}

output "tags" {
  description = "Map of tags assigned to the resource"
  value       = aws_paymentcryptography_key.this.tags
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_paymentcryptography_key.this.tags_all
}