output "id" {
  description = "The ID of the AWS Verified Access trust provider"
  value       = aws_verifiedaccess_trust_provider.this.id
}

output "policy_reference_name" {
  description = "The identifier to be used when working with policy rules"
  value       = aws_verifiedaccess_trust_provider.this.policy_reference_name
}

output "trust_provider_type" {
  description = "The type of trust provider"
  value       = aws_verifiedaccess_trust_provider.this.trust_provider_type
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_verifiedaccess_trust_provider.this.region
}

output "description" {
  description = "A description for the AWS Verified Access trust provider"
  value       = aws_verifiedaccess_trust_provider.this.description
}

output "device_trust_provider_type" {
  description = "The type of device-based trust provider"
  value       = aws_verifiedaccess_trust_provider.this.device_trust_provider_type
}

output "user_trust_provider_type" {
  description = "The type of user-based trust provider"
  value       = aws_verifiedaccess_trust_provider.this.user_trust_provider_type
}

output "device_options" {
  description = "A block of options for device identity based trust providers"
  value       = aws_verifiedaccess_trust_provider.this.device_options
}

output "native_application_oidc_options" {
  description = "The OpenID Connect details for an Native Application OIDC, user-identity based trust provider"
  value       = aws_verifiedaccess_trust_provider.this.native_application_oidc_options
}

output "oidc_options" {
  description = "The OpenID Connect details for an oidc-type, user-identity based trust provider"
  value       = aws_verifiedaccess_trust_provider.this.oidc_options
}

output "tags" {
  description = "Key-value mapping of resource tags"
  value       = aws_verifiedaccess_trust_provider.this.tags
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_verifiedaccess_trust_provider.this.tags_all
}