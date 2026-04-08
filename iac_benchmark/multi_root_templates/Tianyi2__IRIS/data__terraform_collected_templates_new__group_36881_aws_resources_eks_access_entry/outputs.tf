output "access_entry_arn" {
  description = "Amazon Resource Name (ARN) of the Access Entry"
  value       = aws_eks_access_entry.this.access_entry_arn
}

output "created_at" {
  description = "Date and time in RFC3339 format that the EKS add-on was created"
  value       = aws_eks_access_entry.this.created_at
}

output "modified_at" {
  description = "Date and time in RFC3339 format that the EKS add-on was updated"
  value       = aws_eks_access_entry.this.modified_at
}

output "tags_all" {
  description = "Key-value map of resource tags, including those inherited from the provider default_tags configuration block"
  value       = aws_eks_access_entry.this.tags_all
}

output "cluster_name" {
  description = "Name of the EKS Cluster"
  value       = aws_eks_access_entry.this.cluster_name
}

output "principal_arn" {
  description = "The IAM Principal ARN which requires Authentication access to the EKS cluster"
  value       = aws_eks_access_entry.this.principal_arn
}

output "region" {
  description = "Region where this resource will be managed"
  value       = aws_eks_access_entry.this.region
}

output "kubernetes_groups" {
  description = "List of string which can optionally specify the Kubernetes groups the user would belong to when creating an access entry"
  value       = aws_eks_access_entry.this.kubernetes_groups
}

output "tags" {
  description = "Key-value map of resource tags"
  value       = aws_eks_access_entry.this.tags
}

output "type" {
  description = "Type of the access entry"
  value       = aws_eks_access_entry.this.type
}

output "user_name" {
  description = "User name for the access entry"
  value       = aws_eks_access_entry.this.user_name
}