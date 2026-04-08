# Compartment onboarding outputs
output "compartment_service_account_email" {
  description = "The email address of the management service account"
  value       = module.upwind_compartment_onboarding.upwind_management_service_account_email
}

output "identity_domain_oidc_issuer_url" {
  description = "OIDC issuer URL for the Identity Domain (for AWS IAM OIDC provider configuration)"
  value       = module.upwind_compartment_onboarding.identity_domain_oidc_issuer_url
}

output "identity_domain_federation_info" {
  description = "Information needed to configure AWS IAM OIDC provider for OCI federation"
  value       = module.upwind_compartment_onboarding.identity_domain_federation_info
}

output "target_compartment_ids" {
  description = "The list of target compartment IDs that were onboarded"
  value       = module.upwind_compartment_onboarding.target_compartment_ids
}

output "orchestrator_compartment_id" {
  description = "The orchestrator compartment ID"
  value       = module.upwind_compartment_onboarding.configuration.upwind_orchestrator_compartment_id
}

# Summary outputs

output "compartments_onboarded" {
  description = "Whether the compartments were successfully onboarded"
  value       = true
}

