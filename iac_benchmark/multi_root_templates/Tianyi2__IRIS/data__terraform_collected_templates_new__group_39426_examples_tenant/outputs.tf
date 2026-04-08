# Tenant onboarding outputs
output "tenant_service_account_email" {
  description = "The email address of the management service account"
  value       = module.upwind_tenant_onboarding.upwind_management_service_account_email
}

output "identity_domain_oidc_issuer_url" {
  description = "OIDC issuer URL for the Identity Domain (for AWS IAM OIDC provider configuration)"
  value       = module.upwind_tenant_onboarding.identity_domain_oidc_issuer_url
}

output "identity_domain_federation_info" {
  description = "Information needed to configure AWS IAM OIDC provider for OCI federation"
  value       = module.upwind_tenant_onboarding.identity_domain_federation_info
}

output "tenancy_id" {
  description = "The OCI tenancy ID"
  value       = module.upwind_tenant_onboarding.oci_tenancy_id
}

# Summary outputs

output "tenant_onboarded" {
  description = "Whether the tenant was successfully onboarded"
  value       = true
}
