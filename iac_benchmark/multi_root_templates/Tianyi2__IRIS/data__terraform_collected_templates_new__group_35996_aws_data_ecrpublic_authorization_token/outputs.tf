output "authorization_token" {
  description = "Temporary IAM authentication credentials to access the ECR repository encoded in base64 in the form of user_name:password"
  value       = data.aws_ecrpublic_authorization_token.this.authorization_token
}

output "expires_at" {
  description = "Time in UTC RFC3339 format when the authorization token expires"
  value       = data.aws_ecrpublic_authorization_token.this.expires_at
}

output "id" {
  description = "Region of the authorization token"
  value       = data.aws_ecrpublic_authorization_token.this.id
}

output "password" {
  description = "Password decoded from the authorization token"
  value       = data.aws_ecrpublic_authorization_token.this.password
  sensitive   = true
}

output "user_name" {
  description = "User name decoded from the authorization token"
  value       = data.aws_ecrpublic_authorization_token.this.user_name
}