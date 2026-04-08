locals {
  # Validation: bundle_id cannot be combined with owner or name parameters
  validation_bundle_id_exclusive = var.bundle_id != null ? (var.owner == null && var.name == null) : true
}

# Validation checks
check "bundle_id_exclusive" {
  assert {
    condition     = local.validation_bundle_id_exclusive
    error_message = "data_aws_workspaces_bundle: bundle_id cannot be combined with owner or name parameters."
  }
}

data "aws_workspaces_bundle" "this" {
  region    = var.region
  bundle_id = var.bundle_id
  owner     = var.owner
  name      = var.name
}