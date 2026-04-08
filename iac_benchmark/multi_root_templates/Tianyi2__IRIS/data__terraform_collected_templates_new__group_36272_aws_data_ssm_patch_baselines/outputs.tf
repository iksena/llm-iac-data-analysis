output "baseline_identities" {
  description = "List of baseline identities."
  value       = data.aws_ssm_patch_baselines.this.baseline_identities
}

output "baseline_descriptions" {
  description = "List of baseline descriptions."
  value       = [for identity in data.aws_ssm_patch_baselines.this.baseline_identities : identity.baseline_description]
}

output "baseline_ids" {
  description = "List of baseline IDs."
  value       = [for identity in data.aws_ssm_patch_baselines.this.baseline_identities : identity.baseline_id]
}

output "baseline_names" {
  description = "List of baseline names."
  value       = [for identity in data.aws_ssm_patch_baselines.this.baseline_identities : identity.baseline_name]
}

output "default_baselines" {
  description = "List indicating whether each baseline is the default baseline."
  value       = [for identity in data.aws_ssm_patch_baselines.this.baseline_identities : identity.default_baseline]
}

output "operating_systems" {
  description = "List of operating systems each baseline applies to."
  value       = [for identity in data.aws_ssm_patch_baselines.this.baseline_identities : identity.operating_system]
}