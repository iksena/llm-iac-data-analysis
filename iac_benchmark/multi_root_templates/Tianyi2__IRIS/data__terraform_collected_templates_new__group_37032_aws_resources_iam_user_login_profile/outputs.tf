output "password" {
  description = "The plain text password, only available when pgp_key is not provided"
  value       = aws_iam_user_login_profile.this.password
  sensitive   = true
}

output "key_fingerprint" {
  description = "The fingerprint of the PGP key used to encrypt the password. Only available if password was handled on Terraform resource creation, not import"
  value       = aws_iam_user_login_profile.this.key_fingerprint
}

output "encrypted_password" {
  description = "The encrypted password, base64 encoded. Only available if password was handled on Terraform resource creation, not import"
  value       = aws_iam_user_login_profile.this.encrypted_password
  sensitive   = true
}