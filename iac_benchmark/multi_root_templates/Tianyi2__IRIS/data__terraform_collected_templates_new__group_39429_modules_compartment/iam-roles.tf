### Orchestrator Compartment-Level Policies for Management Group
###
### These policies are created at the orchestrator compartment level
### for users with only compartment-level permissions.

# Management group needs orchestrator compartment write access for deployment
resource "oci_identity_policy" "mgmt_group_orchestrator_deploy_compute" {
  compartment_id = local.compartment_id
  name           = format("mgmt-orchestrator-compute-%s", local.resource_suffix_hyphen)
  description    = "Allow management group to manage compute resources in orchestrator compartment"
  freeform_tags  = local.validated_tags
  statements = [
    for perm in module.iam.federated_mgmt_group_orchestrator_deploy_compute_permissions :
    format(perm, local.compartment_id)
  ]
}

resource "oci_identity_policy" "mgmt_group_orchestrator_deploy_network" {
  compartment_id = local.compartment_id
  name           = format("mgmt-orchestrator-network-%s", local.resource_suffix_hyphen)
  description    = "Allow management group to manage network resources in orchestrator compartment"
  freeform_tags  = local.validated_tags
  statements = [
    for perm in module.iam.federated_mgmt_group_orchestrator_deploy_network_permissions :
    format(perm, local.compartment_id)
  ]
}

resource "oci_identity_policy" "mgmt_group_orchestrator_deploy_functions" {
  compartment_id = local.compartment_id
  name           = format("mgmt-orchestrator-functions-%s", local.resource_suffix_hyphen)
  description    = "Allow management group to manage functions and events in orchestrator compartment"
  freeform_tags  = local.validated_tags
  statements = [
    for perm in module.iam.federated_mgmt_group_orchestrator_deploy_functions_permissions :
    format(perm, local.compartment_id)
  ]
}

# Management group secret access
resource "oci_identity_policy" "mgmt_group_secret_access_policy" {
  compartment_id = local.compartment_id
  name           = format("mgmt-secret-access-%s", local.resource_suffix_hyphen)
  description    = "Allow management group to access secrets"
  statements     = module.iam.federated_mgmt_group_secret_access_permissions
  freeform_tags  = local.validated_tags
}

### Target Compartment Policies (created in each target compartment)

# Give the management group the basic viewer role on each target compartment
resource "oci_identity_policy" "upwind_management_group_compartment_viewer_policy" {
  for_each = toset(var.target_compartment_ids)

  compartment_id = each.value
  name           = format("mgmt-compartment-viewer-%s", local.resource_suffix_hyphen)
  description    = "Allow management group to view compartment resources"
  freeform_tags  = local.validated_tags
  statements = [
    "Allow group id ${module.iam.federated_mgmt_group.ocid} to read all-resources in compartment id ${each.value}"
  ]
}

# Grant Cloud Asset Inventory permissions on each target compartment
resource "oci_identity_policy" "upwind_management_group_asset_viewer_policy" {
  for_each = toset(var.target_compartment_ids)

  compartment_id = each.value
  name           = format("mgmt-asset-viewer-%s", local.resource_suffix_hyphen)
  description    = "Allow management group to view assets"
  freeform_tags  = local.validated_tags
  statements = [
    "Allow group id ${module.iam.federated_mgmt_group.ocid} to read all-resources in compartment id ${each.value}"
  ]
}
