output "id" {
  description = "Cluster name"
  value       = data.aws_eks_node_groups.this.id
}

output "names" {
  description = "Set of all node group names in an EKS Cluster"
  value       = data.aws_eks_node_groups.this.names
}