output "access_entry_arn" {
  description = "Amazon Resource Name (ARN) of the Access Entry."
  value       = data.aws_eks_access_entry.this.access_entry_arn
}

output "created_at" {
  description = "Date and time in RFC3339 format that the EKS add-on was created."
  value       = data.aws_eks_access_entry.this.created_at
}

output "kubernetes_groups" {
  description = "List of string which can optionally specify the Kubernetes groups the user would belong to when creating an access entry."
  value       = data.aws_eks_access_entry.this.kubernetes_groups
}

output "modified_at" {
  description = "Date and time in RFC3339 format that the EKS add-on was updated."
  value       = data.aws_eks_access_entry.this.modified_at
}

output "user_name" {
  description = "Defaults to principal ARN if user is principal else defaults to assume-role/session-name is role is used."
  value       = data.aws_eks_access_entry.this.user_name
}

output "type" {
  description = "Defaults to STANDARD which provides the standard workflow. EC2_LINUX, EC2_WINDOWS, FARGATE_LINUX types disallow users to input a username or groups, and prevent associations."
  value       = data.aws_eks_access_entry.this.type
}

output "tags_all" {
  description = "Key-value map of resource tags, including those inherited from the provider default_tags configuration block."
  value       = data.aws_eks_access_entry.this.tags_all
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_eks_access_entry.this.region
}

output "cluster_name" {
  description = "Name of the EKS Cluster."
  value       = data.aws_eks_access_entry.this.cluster_name
}

output "principal_arn" {
  description = "The IAM Principal ARN which requires Authentication access to the EKS cluster."
  value       = data.aws_eks_access_entry.this.principal_arn
}