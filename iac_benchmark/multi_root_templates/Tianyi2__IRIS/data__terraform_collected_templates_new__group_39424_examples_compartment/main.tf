# Compartment-level example: Onboard specific OCI compartments to Upwind
module "upwind_compartment_onboarding" {
  source = "../../modules/compartment"

  target_compartment_ids = var.target_compartment_ids

  # Required Upwind configuration
  upwind_organization_id = var.upwind_organization_id
  upwind_client_id       = var.upwind_client_id
  upwind_client_secret   = var.upwind_client_secret

  # Required OCI configuration
  oci_tenancy_id                     = var.oci_tenancy_id
  upwind_orchestrator_compartment_id = var.upwind_orchestrator_compartment_id

  # Optional configuration
  enable_cloudscanners  = var.enable_cloudscanners
  scanner_client_id     = var.scanner_client_id
  scanner_client_secret = var.scanner_client_secret
  enable_dspm_scanning  = var.enable_dspm_scanning
  resource_suffix       = var.resource_suffix
  is_dev                = var.is_dev

  # Tags
  tags = var.tags
}

