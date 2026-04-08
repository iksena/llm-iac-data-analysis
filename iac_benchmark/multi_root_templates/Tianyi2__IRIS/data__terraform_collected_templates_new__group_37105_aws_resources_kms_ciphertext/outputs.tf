output "ciphertext_blob" {
  description = "Base64 encoded ciphertext"
  value       = aws_kms_ciphertext.this.ciphertext_blob
}