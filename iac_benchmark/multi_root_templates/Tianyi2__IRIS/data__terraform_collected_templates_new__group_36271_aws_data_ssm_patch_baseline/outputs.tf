output "approved_patches" {
  description = "List of explicitly approved patches for the baseline."
  value       = data.aws_ssm_patch_baseline.this.approved_patches
}

output "approved_patches_compliance_level" {
  description = "Compliance level for approved patches."
  value       = data.aws_ssm_patch_baseline.this.approved_patches_compliance_level
}

output "approved_patches_enable_non_security" {
  description = "Indicates whether the list of approved patches includes non-security updates that should be applied to the instances."
  value       = data.aws_ssm_patch_baseline.this.approved_patches_enable_non_security
}

output "approval_rule" {
  description = "List of rules used to include patches in the baseline."
  value       = data.aws_ssm_patch_baseline.this.approval_rule
}

output "available_security_updates_compliance_status" {
  description = "Indicates the compliance status of managed nodes for which security-related patches are available but were not approved. Supported for Windows Server managed nodes only."
  value       = data.aws_ssm_patch_baseline.this.available_security_updates_compliance_status
}

output "global_filter" {
  description = "Set of global filters used to exclude patches from the baseline."
  value       = data.aws_ssm_patch_baseline.this.global_filter
}

output "id" {
  description = "ID of the baseline."
  value       = data.aws_ssm_patch_baseline.this.id
}

output "json" {
  description = "JSON representation of the baseline."
  value       = data.aws_ssm_patch_baseline.this.json
}

output "name" {
  description = "Name of the baseline."
  value       = data.aws_ssm_patch_baseline.this.name
}

output "description" {
  description = "Description of the baseline."
  value       = data.aws_ssm_patch_baseline.this.description
}

output "rejected_patches" {
  description = "List of rejected patches."
  value       = data.aws_ssm_patch_baseline.this.rejected_patches
}

output "rejected_patches_action" {
  description = "Action specified to take on patches included in the rejected_patches list."
  value       = data.aws_ssm_patch_baseline.this.rejected_patches_action
}

output "source" {
  description = "Information about the patches to use to update the managed nodes, including target operating systems and source repositories."
  value       = data.aws_ssm_patch_baseline.this.source
}

output "owner" {
  description = "Owner of the baseline."
  value       = data.aws_ssm_patch_baseline.this.owner
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_ssm_patch_baseline.this.region
}

output "default_baseline" {
  description = "Baseline default_baseline field value."
  value       = data.aws_ssm_patch_baseline.this.default_baseline
}

output "name_prefix" {
  description = "Baseline name prefix filter value."
  value       = data.aws_ssm_patch_baseline.this.name_prefix
}

output "operating_system" {
  description = "Specified OS for the baseline."
  value       = data.aws_ssm_patch_baseline.this.operating_system
}