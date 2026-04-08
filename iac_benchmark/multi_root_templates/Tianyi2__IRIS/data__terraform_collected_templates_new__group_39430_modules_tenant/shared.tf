module "iam" {
  source = "../_shared/iam"

  # OCI Configuration
  oci_region                         = var.oci_region
  oci_tenancy_id                     = var.oci_tenancy_id
  upwind_orchestrator_compartment_id = local.compartment_id

  # Upwind Configuration
  upwind_organization_id = var.upwind_organization_id
  upwind_client_id       = var.upwind_client_id
  upwind_client_secret   = var.upwind_client_secret
  scanner_client_id      = var.scanner_client_id
  scanner_client_secret  = var.scanner_client_secret
  resource_suffix        = var.resource_suffix
  enable_cloudscanners   = var.enable_cloudscanners
  tags                   = var.tags
  default_tags           = var.default_tags
  upwind_region          = var.upwind_region
  is_dev                 = var.is_dev

  # Workload Identity Federation Configuration
  root_level_compartment_id       = var.root_level_compartment_id != "" ? var.root_level_compartment_id : var.oci_tenancy_id
  oci_domain_id                   = var.oci_domain_id
  identity_domain_display_name    = var.identity_domain_display_name
  identity_domain_description     = var.identity_domain_description
  identity_domain_license_type    = var.identity_domain_license_type
  identity_domain_name            = var.identity_domain_name
  identity_domain_oidc_issuer_url = var.identity_domain_oidc_issuer_url
  aws_federated_group_name        = var.aws_federated_group_name

  # Vault Configuration
  oci_vault_id     = var.oci_vault_id
  oci_vault_key_id = var.oci_vault_key_id
}
