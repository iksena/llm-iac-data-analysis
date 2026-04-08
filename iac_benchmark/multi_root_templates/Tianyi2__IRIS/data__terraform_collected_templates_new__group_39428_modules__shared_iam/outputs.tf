### Dynamic Groups and Users

output "upwind_management_user" {
  description = "The Upwind Management User details."
  value       = oci_identity_user.upwind_management_user
}

output "upwind_ro_user" {
  description = "The Upwind Reader User details."
  value       = oci_identity_user.upwind_ro_user
}

output "cloudscanner_dg" {
  description = "The Cloudscanner Dynamic Group details (handles both scanning and scaling)."
  value       = var.enable_cloudscanners ? oci_identity_dynamic_group.cloudscanner_dg[0] : null
}

output "cloudscanner_user" {
  description = "The Cloudscanner User details (handles both scanning and scaling)."
  value       = var.enable_cloudscanners ? oci_identity_user.cloudscanner_user[0] : null
}

### Vault Resources

output "vault" {
  description = "The Vault resource details (either created or existing)."
  value       = var.oci_vault_id != "" ? data.oci_kms_vault.existing_vault[0] : oci_kms_vault.upwind_vault[0]
}

output "vault_key" {
  description = "The Vault Key resource details (either created or existing)."
  value = var.oci_vault_key_id != "" ? data.oci_kms_key.existing_vault_key[0] : (
    var.oci_vault_id != "" ? oci_kms_key.upwind_vault_key_existing_vault[0] : oci_kms_key.upwind_vault_key[0]
  )
}

output "oci_vault_secret" {
  description = "The secrets created in Vault."
  value = {
    upwind_client_id      = oci_vault_secret.upwind_client_id
    upwind_client_secret  = oci_vault_secret.upwind_client_secret
    scanner_client_id     = var.enable_cloudscanners ? oci_vault_secret.scanner_client_id[0] : null
    scanner_client_secret = var.enable_cloudscanners ? oci_vault_secret.scanner_client_secret[0] : null
    terraform_tags        = oci_vault_secret.terraform_tags
  }
}

### CloudScanner Dynamic Group Permissions

output "cloudscanner_tenancy_compute_read_permissions" {
  description = "CloudScanner dynamic group tenancy-wide compute read permissions."
  value       = local.cloudscanner_tenancy_compute_read_permissions_list
}

output "cloudscanner_tenancy_snapshot_create_permissions" {
  description = "CloudScanner dynamic group tenancy-wide snapshot creation permissions."
  value       = local.cloudscanner_tenancy_snapshot_create_permissions_list
}

output "cloudscanner_orchestrator_volume_permissions" {
  description = "CloudScanner dynamic group orchestrator compartment volume permissions."
  value       = local.cloudscanner_orchestrator_volume_permissions_list
}

output "cloudscanner_orchestrator_volume_delete_permissions" {
  description = "CloudScanner dynamic group orchestrator compartment volume deletion permissions."
  value       = local.cloudscanner_orchestrator_volume_delete_permissions_list
}

output "cloudscanner_secret_access_permissions" {
  description = "CloudScanner dynamic group secret access permissions."
  value       = local.cloudscanner_secret_access_permissions_list
}

output "cloudscanner_functions_permissions" {
  description = "CloudScanner dynamic group functions permissions."
  value       = local.cloudscanner_functions_permissions_list
}

output "cloudscanner_object_storage_permissions" {
  description = "CloudScanner dynamic group object storage permissions."
  value       = local.cloudscanner_object_storage_permissions_list
}

output "cloudscanner_networking_permissions" {
  description = "CloudScanner dynamic group networking permissions."
  value       = local.cloudscanner_networking_permissions_list
}

### Tags

output "tags" {
  description = "Tags applied to all resources."
  value       = var.tags
}

output "default_tags" {
  description = "Default tags applied to all resources (can be overridden)."
  value       = var.default_tags
}

### Workload Identity Federation

output "identity_domain_federation_info" {
  description = "Information needed to configure AWS IAM OIDC provider for OCI federation"
  value = {
    identity_domain_id   = local.should_create_domain ? try(oci_identity_domain.upwind_identity_domain[0].id, var.oci_domain_id) : var.oci_domain_id
    identity_domain_name = local.should_create_domain ? try(oci_identity_domain.upwind_identity_domain[0].display_name, var.identity_domain_name) : var.identity_domain_name
    oidc_issuer_url      = var.identity_domain_oidc_issuer_url != "" ? var.identity_domain_oidc_issuer_url : data.oci_identity_domain.upwind_identity_domain.url
    management_user_name = oci_identity_user.upwind_management_user.name
    federated_group_name = oci_identity_domains_group.upwind_federated_mgmt_group.display_name
    aws_account_id       = var.is_dev ? "437279811180" : "627244208106"
  }
  sensitive = false
}

output "identity_domain" {
  description = "The created identity domain resource (if a new domain was created)"
  value       = local.should_create_domain ? try(oci_identity_domain.upwind_identity_domain[0], null) : null
}

output "upwind_identity_domain_app_id" {
  description = "The ID of the Upwind Identity Domain OIDC client app"
  value       = oci_identity_domains_app.upwind_identity_domain_oidc_client.id
}

output "confidential_app_client_id" {
  description = "The client ID of the confidential OAuth client app for workload identity federation"
  value       = oci_identity_domains_app.upwind_identity_domain_oidc_client.name
}

output "confidential_app_client_secret" {
  description = "The client secret of the confidential OAuth client app for workload identity federation"
  value       = oci_identity_domains_app.upwind_identity_domain_oidc_client.client_secret
  sensitive   = true
}

### Federated Management Group Permissions

output "federated_mgmt_group" {
  description = "The Identity Domain group for federated management users."
  value       = oci_identity_domains_group.upwind_federated_mgmt_group
}

output "federated_mgmt_group_orchestrator_deploy_compute_permissions" {
  description = "Federated management group orchestrator compartment compute deployment permissions (use format() with compartment_id)."
  value       = local.federated_mgmt_group_orchestrator_deploy_compute_permissions_list
}

output "federated_mgmt_group_orchestrator_deploy_network_permissions" {
  description = "Federated management group orchestrator compartment network deployment permissions (use format() with compartment_id)."
  value       = local.federated_mgmt_group_orchestrator_deploy_network_permissions_list
}

output "federated_mgmt_group_orchestrator_deploy_functions_permissions" {
  description = "Federated management group orchestrator compartment functions deployment permissions (use format() with compartment_id)."
  value       = local.federated_mgmt_group_orchestrator_deploy_functions_permissions_list
}

output "federated_mgmt_group_tenancy_read_permissions" {
  description = "Federated management group tenancy-wide read permissions (tenant mode only)."
  value       = local.federated_mgmt_group_tenancy_read_permissions_list
}

output "federated_mgmt_group_tenancy_iam_permissions" {
  description = "Federated management group tenancy-level IAM permissions (tenant mode only)."
  value       = local.federated_mgmt_group_tenancy_iam_permissions_list
}

output "federated_mgmt_group_secret_access_permissions" {
  description = "Federated management group secret access permissions."
  value       = local.federated_mgmt_group_secret_access_permissions_list
}
