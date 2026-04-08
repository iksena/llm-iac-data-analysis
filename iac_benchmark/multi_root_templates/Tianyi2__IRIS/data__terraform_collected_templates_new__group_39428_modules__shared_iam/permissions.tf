locals {
  # Define permission strings with direct dynamic group names and scope placeholders
  # Format: ${var.upwind_orchestrator_compartment_id} = compartment or tenancy scope placeholder

  # CloudScanner Dynamic Group Permissions
  # Tenancy-wide compute resource read access
  cloudscanner_tenancy_compute_read_permissions_list = var.enable_cloudscanners ? [
    "Allow dynamic-group ${oci_identity_dynamic_group.cloudscanner_dg[0].name} to read instances in tenancy",
    "Allow dynamic-group ${oci_identity_dynamic_group.cloudscanner_dg[0].name} to read boot-volumes in tenancy",
    "Allow dynamic-group ${oci_identity_dynamic_group.cloudscanner_dg[0].name} to read block-volumes in tenancy",
    "Allow dynamic-group ${oci_identity_dynamic_group.cloudscanner_dg[0].name} to read instance-configurations in tenancy",
    "Allow dynamic-group ${oci_identity_dynamic_group.cloudscanner_dg[0].name} to read instance-pools in tenancy",
    "Allow dynamic-group ${oci_identity_dynamic_group.cloudscanner_dg[0].name} to read work-requests in tenancy"
  ] : []

  # Tenancy-wide snapshot creation permissions
  cloudscanner_tenancy_snapshot_create_permissions_list = var.enable_cloudscanners ? [
    "Allow dynamic-group ${oci_identity_dynamic_group.cloudscanner_dg[0].name} to manage volume-family in tenancy",
    "Allow dynamic-group ${oci_identity_dynamic_group.cloudscanner_dg[0].name} to manage boot-volume-backups in tenancy",
  ] : []

  # Orchestrator compartment volume management permissions
  cloudscanner_orchestrator_volume_permissions_list = var.enable_cloudscanners ? [
    "Allow dynamic-group ${oci_identity_dynamic_group.cloudscanner_dg[0].name} to read block-volumes in compartment id ${var.upwind_orchestrator_compartment_id}",
    "Allow dynamic-group ${oci_identity_dynamic_group.cloudscanner_dg[0].name} to read boot-volumes in compartment id ${var.upwind_orchestrator_compartment_id}",
    "Allow dynamic-group ${oci_identity_dynamic_group.cloudscanner_dg[0].name} to manage instances in compartment id ${var.upwind_orchestrator_compartment_id}",
    "Allow dynamic-group ${oci_identity_dynamic_group.cloudscanner_dg[0].name} to manage instance-pools in compartment id ${var.upwind_orchestrator_compartment_id}",
    "Allow dynamic-group ${oci_identity_dynamic_group.cloudscanner_dg[0].name} to manage instance-configurations in compartment id ${var.upwind_orchestrator_compartment_id}"
  ] : []

  # Orchestrator compartment volume deletion with conditions
  cloudscanner_orchestrator_volume_delete_permissions_list = var.enable_cloudscanners ? [
    "Allow dynamic-group ${oci_identity_dynamic_group.cloudscanner_dg[0].name} to manage block-volumes in compartment id ${var.upwind_orchestrator_compartment_id} where target.block-volume.name = /vol-*/",
    "Allow dynamic-group ${oci_identity_dynamic_group.cloudscanner_dg[0].name} to manage boot-volumes in compartment id ${var.upwind_orchestrator_compartment_id} where target.boot-volume.name = /vol-*/"
  ] : []

  # CloudScanner secret access
  cloudscanner_secret_access_permissions_list = var.enable_cloudscanners ? [
    "Allow dynamic-group ${oci_identity_dynamic_group.cloudscanner_dg[0].name} to read secrets in compartment id ${var.upwind_orchestrator_compartment_id}",
    "Allow dynamic-group ${oci_identity_dynamic_group.cloudscanner_dg[0].name} to use vaults in compartment id ${var.upwind_orchestrator_compartment_id}"
  ] : []

  # CloudScanner functions permissions
  cloudscanner_functions_permissions_list = var.enable_cloudscanners ? [
    "Allow dynamic-group ${oci_identity_dynamic_group.cloudscanner_dg[0].name} to manage functions-family in compartment id ${var.upwind_orchestrator_compartment_id}"
  ] : []

  # CloudScanner object storage permissions
  cloudscanner_object_storage_permissions_list = var.enable_cloudscanners ? [
    "Allow dynamic-group ${oci_identity_dynamic_group.cloudscanner_dg[0].name} to read buckets in compartment id ${var.upwind_orchestrator_compartment_id}",
    "Allow dynamic-group ${oci_identity_dynamic_group.cloudscanner_dg[0].name} to read objects in compartment id ${var.upwind_orchestrator_compartment_id}",
  ] : []

  # CloudScanner networking permissions for scaling
  cloudscanner_networking_permissions_list = var.enable_cloudscanners ? [
    "Allow dynamic-group ${oci_identity_dynamic_group.cloudscanner_dg[0].name} to manage subnets in compartment id ${var.upwind_orchestrator_compartment_id}",
    "Allow dynamic-group ${oci_identity_dynamic_group.cloudscanner_dg[0].name} to use subnets in compartment id ${var.upwind_orchestrator_compartment_id}"
  ] : []
}
