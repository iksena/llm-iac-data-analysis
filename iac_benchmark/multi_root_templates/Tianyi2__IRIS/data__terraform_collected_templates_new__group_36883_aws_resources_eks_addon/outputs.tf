output "arn" {
  description = "Amazon Resource Name (ARN) of the EKS add-on."
  value       = aws_eks_addon.this.arn
}

output "id" {
  description = "EKS Cluster name and EKS Addon name separated by a colon (:)."
  value       = aws_eks_addon.this.id
}

# NOTE: The status, created_at, and modified_at attributes are not available
# in the current AWS provider version (6.12.0). These attributes exist in the 
# AWS EKS API but are not exposed by the Terraform provider at this time.

output "tags_all" {
  description = "Key-value map of resource tags, including those inherited from the provider default_tags configuration block."
  value       = aws_eks_addon.this.tags_all
}