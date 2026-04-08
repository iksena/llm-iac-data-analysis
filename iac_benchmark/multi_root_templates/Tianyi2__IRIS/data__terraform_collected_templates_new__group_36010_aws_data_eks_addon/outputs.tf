output "arn" {
  description = "ARN of the EKS add-on."
  value       = data.aws_eks_addon.this.arn
}

output "addon_version" {
  description = "Version of EKS add-on."
  value       = data.aws_eks_addon.this.addon_version
}

output "configuration_values" {
  description = "Configuration values for the addon with a single JSON string."
  value       = data.aws_eks_addon.this.configuration_values
}

output "service_account_role_arn" {
  description = "ARN of IAM role used for EKS add-on. If value is empty - then add-on uses the IAM role assigned to the EKS Cluster node."
  value       = data.aws_eks_addon.this.service_account_role_arn
}

output "pod_identity_association" {
  description = "Pod identity association for the EKS add-on."
  value       = data.aws_eks_addon.this.pod_identity_association
}

output "id" {
  description = "EKS Cluster name and EKS add-on name separated by a colon (:)."
  value       = data.aws_eks_addon.this.id
}

output "created_at" {
  description = "Date and time in RFC3339 format that the EKS add-on was created."
  value       = data.aws_eks_addon.this.created_at
}

output "modified_at" {
  description = "Date and time in RFC3339 format that the EKS add-on was updated."
  value       = data.aws_eks_addon.this.modified_at
}