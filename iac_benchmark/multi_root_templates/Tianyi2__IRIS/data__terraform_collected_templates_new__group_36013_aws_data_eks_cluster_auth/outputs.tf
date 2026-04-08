output "id" {
  description = "Name of the cluster."
  value       = data.aws_eks_cluster_auth.this.id
}

output "token" {
  description = "Token to use to authenticate with the cluster."
  value       = data.aws_eks_cluster_auth.this.token
  sensitive   = true
}