### Orchestrator Compartment-Level Policies for CloudScanner Dynamic Group
###
### These policies are created at the orchestrator compartment level
### for users with only compartment-level permissions.
###
### NOTE: Volume and snapshot deletion policies are in modules/_shared/iam/roles.tf

# CloudScanner secret access
resource "oci_identity_policy" "cs_dg_secret_access_policy" {
  count          = var.enable_cloudscanners ? 1 : 0
  compartment_id = local.compartment_id
  name           = format("cs-secret-access-%s", local.resource_suffix_hyphen)
  description    = "Allow cloudscanner dynamic group to access secrets"
  statements     = module.iam.cloudscanner_secret_access_permissions
  freeform_tags  = local.validated_tags
}

# CloudScanner functions permissions
resource "oci_identity_policy" "cs_dg_functions_policy" {
  count          = var.enable_cloudscanners ? 1 : 0
  compartment_id = local.compartment_id
  name           = format("cs-functions-%s", local.resource_suffix_hyphen)
  description    = "Allow cloudscanner dynamic group to manage functions"
  statements     = module.iam.cloudscanner_functions_permissions
  freeform_tags  = local.validated_tags
}

# CloudScanner object storage permissions
resource "oci_identity_policy" "cs_dg_object_storage_policy" {
  count          = var.enable_cloudscanners ? 1 : 0
  compartment_id = local.compartment_id
  name           = format("cs-object-storage-%s", local.resource_suffix_hyphen)
  description    = "Allow cloudscanner dynamic group to access object storage"
  statements     = module.iam.cloudscanner_object_storage_permissions
  freeform_tags  = local.validated_tags
}

# CloudScanner networking permissions for scaling
resource "oci_identity_policy" "cs_dg_networking_policy" {
  count          = var.enable_cloudscanners ? 1 : 0
  compartment_id = local.compartment_id
  name           = format("cs-networking-%s", local.resource_suffix_hyphen)
  description    = "Allow cloudscanner dynamic group to manage networking for scaling"
  statements     = module.iam.cloudscanner_networking_permissions
  freeform_tags  = local.validated_tags
}

### Target Compartment Policies (created in each target compartment)

# Grant compute viewer policy to CloudScanner dynamic group on each target compartment
resource "oci_identity_policy" "upwind_cloudscanner_dg_compute_viewer_policy" {
  for_each = var.enable_cloudscanners ? toset(var.target_compartment_ids) : toset([])

  compartment_id = each.value
  name           = format("cs-compute-viewer-%s", local.resource_suffix_hyphen)
  description    = "Allow cloudscanner dynamic group to view compute resources"
  freeform_tags  = local.validated_tags
  statements = [
    "Allow dynamic-group ${module.iam.cloudscanner_dg[0].name} to read instances in compartment id ${each.value}",
    "Allow dynamic-group ${module.iam.cloudscanner_dg[0].name} to read boot-volumes in compartment id ${each.value}",
    "Allow dynamic-group ${module.iam.cloudscanner_dg[0].name} to read block-volumes in compartment id ${each.value}"
  ]
}
