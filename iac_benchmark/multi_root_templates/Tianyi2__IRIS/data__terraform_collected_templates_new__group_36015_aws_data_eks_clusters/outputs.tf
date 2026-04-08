output "id" {
  description = "AWS Region."
  value       = data.aws_eks_clusters.this.id
}

output "names" {
  description = "Set of EKS clusters names"
  value       = data.aws_eks_clusters.this.names
}