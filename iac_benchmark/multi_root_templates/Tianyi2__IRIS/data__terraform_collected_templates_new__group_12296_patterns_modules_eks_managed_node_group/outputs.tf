output "node_group_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Node Group"
  value       = module.eks_managed_node_group.node_group_arn
}

output "node_group_id" {
  description = "EKS Node Group ID"
  value       = module.eks_managed_node_group.node_group_id
}

output "node_group_resources" {
  description = "List of objects containing information about underlying resources of the EKS Node Group"
  value       = module.eks_managed_node_group.node_group_resources
}

output "iam_role_arn" {
  description = "IAM role ARN for EKS Node Group"
  value       = module.eks_managed_node_group.iam_role_arn
}

output "iam_role_name" {
  description = "IAM role name for EKS Node Group"
  value       = module.eks_managed_node_group.iam_role_name
}