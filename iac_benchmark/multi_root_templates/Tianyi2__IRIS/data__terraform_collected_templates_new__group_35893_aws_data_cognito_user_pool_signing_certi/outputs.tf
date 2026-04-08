output "certificate" {
  description = "Certificate string"
  value       = data.aws_cognito_user_pool_signing_certificate.this.certificate
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_cognito_user_pool_signing_certificate.this.region
}

output "user_pool_id" {
  description = "Cognito user pool ID"
  value       = data.aws_cognito_user_pool_signing_certificate.this.user_pool_id
}