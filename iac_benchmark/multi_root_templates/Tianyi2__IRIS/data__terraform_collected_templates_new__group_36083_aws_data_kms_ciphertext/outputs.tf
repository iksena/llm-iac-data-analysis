output "id" {
  description = "Globally unique key ID for the customer master key."
  value       = data.aws_kms_ciphertext.this.id
}

output "ciphertext_blob" {
  description = "Base64 encoded ciphertext"
  value       = data.aws_kms_ciphertext.this.ciphertext_blob
  sensitive   = true
}