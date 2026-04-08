output "create_date" {
  description = "Date and time in RFC3339 format that the access key was created."
  value       = aws_iam_access_key.this.create_date
}

output "encrypted_secret" {
  description = "Encrypted secret, base64 encoded, if `pgp_key` was specified. This attribute is not available for imported resources. The encrypted secret may be decrypted using the command line, for example: `terraform output -raw encrypted_secret | base64 --decode | keybase pgp decrypt`."
  value       = aws_iam_access_key.this.encrypted_secret
}

output "encrypted_ses_smtp_password_v4" {
  description = "Encrypted SES SMTP password, base64 encoded, if `pgp_key` was specified. This attribute is not available for imported resources. The encrypted password may be decrypted using the command line, for example: `terraform output -raw encrypted_ses_smtp_password_v4 | base64 --decode | keybase pgp decrypt`."
  value       = aws_iam_access_key.this.encrypted_ses_smtp_password_v4
}

output "id" {
  description = "Access key ID."
  value       = aws_iam_access_key.this.id
}

output "key_fingerprint" {
  description = "Fingerprint of the PGP key used to encrypt the secret. This attribute is not available for imported resources."
  value       = aws_iam_access_key.this.key_fingerprint
}

output "secret" {
  description = "Secret access key. This attribute is not available for imported resources. Note that this will be written to the state file. If you use this, please protect your backend state file judiciously. Alternatively, you may supply a `pgp_key` instead, which will prevent the secret from being stored in plaintext, at the cost of preventing the use of the secret key in automation."
  value       = aws_iam_access_key.this.secret
  sensitive   = true
}

output "ses_smtp_password_v4" {
  description = "Secret access key converted into an SES SMTP password by applying AWS's documented Sigv4 conversion algorithm. This attribute is not available for imported resources. As SigV4 is region specific, valid Provider regions are `ap-south-1`, `ap-southeast-2`, `eu-central-1`, `eu-west-1`, `us-east-1` and `us-west-2`. See current AWS SES regions."
  value       = aws_iam_access_key.this.ses_smtp_password_v4
  sensitive   = true
}