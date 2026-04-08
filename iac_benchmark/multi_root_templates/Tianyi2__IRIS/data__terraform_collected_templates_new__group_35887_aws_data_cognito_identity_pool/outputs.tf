output "id" {
  description = "An identity pool ID, e.g. us-west-2:1a234567-8901-234b-5cde-f6789g01h2i3."
  value       = data.aws_cognito_identity_pool.this.id
}

output "arn" {
  description = "ARN of the Pool."
  value       = data.aws_cognito_identity_pool.this.arn
}

output "allow_unauthenticated_identities" {
  description = "Whether the identity pool supports unauthenticated logins or not."
  value       = data.aws_cognito_identity_pool.this.allow_unauthenticated_identities
}

output "allow_classic_flow" {
  description = "Whether the classic / basic authentication flow is enabled."
  value       = data.aws_cognito_identity_pool.this.allow_classic_flow
}

output "developer_provider_name" {
  description = "The \"domain\" by which Cognito will refer to your users."
  value       = data.aws_cognito_identity_pool.this.developer_provider_name
}

output "cognito_identity_providers" {
  description = "An array of Amazon Cognito Identity user pools and their client IDs."
  value       = data.aws_cognito_identity_pool.this.cognito_identity_providers
}

output "openid_connect_provider_arns" {
  description = "Set of OpendID Connect provider ARNs."
  value       = data.aws_cognito_identity_pool.this.openid_connect_provider_arns
}

output "saml_provider_arns" {
  description = "An array of Amazon Resource Names (ARNs) of the SAML provider for your identity."
  value       = data.aws_cognito_identity_pool.this.saml_provider_arns
}

output "supported_login_providers" {
  description = "Key-Value pairs mapping provider names to provider app IDs."
  value       = data.aws_cognito_identity_pool.this.supported_login_providers
}

output "tags" {
  description = "A map of tags to assigned to the Identity Pool."
  value       = data.aws_cognito_identity_pool.this.tags
}