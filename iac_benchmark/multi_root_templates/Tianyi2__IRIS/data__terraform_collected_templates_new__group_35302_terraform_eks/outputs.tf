output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = aws_eks_cluster.eks_project.endpoint
}

output "cluster_name" {
  description = "Endpoint for EKS control plane."
  value       = aws_eks_cluster.eks_project.name
}

