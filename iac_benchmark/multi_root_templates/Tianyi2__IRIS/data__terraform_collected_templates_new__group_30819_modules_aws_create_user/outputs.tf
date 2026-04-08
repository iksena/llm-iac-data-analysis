output "access_key_id" {
  value = aws_iam_user.user.unique_id
  description = "unique access key ID generated for the user"
}

output "secret" {
  value = aws_iam_access_key.key.encrypted_secret
  description = "secret key generated for the user"
}