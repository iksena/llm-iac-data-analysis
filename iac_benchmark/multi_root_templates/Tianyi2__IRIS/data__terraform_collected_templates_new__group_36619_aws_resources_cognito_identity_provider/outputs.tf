output "user_pool_id" {
  description = "The user pool id"
  value       = aws_cognito_identity_provider.this.user_pool_id
}

output "provider_name" {
  description = "The provider name"
  value       = aws_cognito_identity_provider.this.provider_name
}

output "provider_type" {
  description = "The provider type"
  value       = aws_cognito_identity_provider.this.provider_type
}

output "attribute_mapping" {
  description = "The map of attribute mapping of user pool attributes"
  value       = aws_cognito_identity_provider.this.attribute_mapping
}

output "idp_identifiers" {
  description = "The list of identity providers"
  value       = aws_cognito_identity_provider.this.idp_identifiers
}

output "provider_details" {
  description = "The map of identity details"
  value       = aws_cognito_identity_provider.this.provider_details
  sensitive   = true
}