### Tenancy-Level Policies for CloudScanner Dynamic Group
###
### These policies require tenancy-level permissions and are only created when deploying
### from the tenant module (user has tenancy-level access).
### For compartment-level deployments, see modules/compartment/iam-roles-cloudscanner.tf

# CloudScanner needs tenancy-wide compute read access for resource discovery
resource "oci_identity_policy" "cs_dg_tenancy_compute_read_policy" {
  count          = var.enable_cloudscanners ? 1 : 0
  compartment_id = var.oci_tenancy_id
  name           = format("cs-tenancy-compute-read-%s", local.resource_suffix_hyphen)
  description    = "Allow cloudscanner dynamic group to read compute resources in tenancy"
  statements     = module.iam.cloudscanner_tenancy_compute_read_permissions
  freeform_tags  = local.validated_tags
}

# CloudScanner needs tenancy-wide snapshot management
resource "oci_identity_policy" "cs_dg_tenancy_snapshot_create_policy" {
  count          = var.enable_cloudscanners ? 1 : 0
  compartment_id = var.oci_tenancy_id
  name           = format("cs-tenancy-snapshot-create-%s", local.resource_suffix_hyphen)
  description    = "Allow cloudscanner dynamic group to create snapshots in tenancy"
  statements     = module.iam.cloudscanner_tenancy_snapshot_create_permissions
  freeform_tags  = local.validated_tags
}

### Tenancy-Level Policies for CloudScanner Dynamic Group (continued)
###
### NOTE: Orchestrator compartment-level policies (volume, snapshot deletion) are now
### in modules/_shared/iam/roles.tf as compartment-scoped policies.

# CloudScanner secret access
resource "oci_identity_policy" "cs_dg_secret_access_policy" {
  count          = var.enable_cloudscanners ? 1 : 0
  compartment_id = var.oci_tenancy_id
  name           = format("cs-secret-access-%s", local.resource_suffix_hyphen)
  description    = "Allow cloudscanner dynamic group to access secrets"
  statements     = module.iam.cloudscanner_secret_access_permissions
  freeform_tags  = local.validated_tags
}

# CloudScanner functions permissions
resource "oci_identity_policy" "cs_dg_functions_policy" {
  count          = var.enable_cloudscanners ? 1 : 0
  compartment_id = var.oci_tenancy_id
  name           = format("cs-functions-%s", local.resource_suffix_hyphen)
  description    = "Allow cloudscanner dynamic group to manage functions"
  statements     = module.iam.cloudscanner_functions_permissions
  freeform_tags  = local.validated_tags
}

# CloudScanner object storage permissions
resource "oci_identity_policy" "cs_dg_object_storage_policy" {
  count          = var.enable_cloudscanners ? 1 : 0
  compartment_id = var.oci_tenancy_id
  name           = format("cs-object-storage-%s", local.resource_suffix_hyphen)
  description    = "Allow cloudscanner dynamic group to access object storage"
  statements     = module.iam.cloudscanner_object_storage_permissions
  freeform_tags  = local.validated_tags
}

# CloudScanner networking permissions for scaling
resource "oci_identity_policy" "cs_dg_networking_policy" {
  count          = var.enable_cloudscanners ? 1 : 0
  compartment_id = var.oci_tenancy_id
  name           = format("cs-networking-%s", local.resource_suffix_hyphen)
  description    = "Allow cloudscanner dynamic group to manage networking for scaling"
  statements     = module.iam.cloudscanner_networking_permissions
  freeform_tags  = local.validated_tags
}
