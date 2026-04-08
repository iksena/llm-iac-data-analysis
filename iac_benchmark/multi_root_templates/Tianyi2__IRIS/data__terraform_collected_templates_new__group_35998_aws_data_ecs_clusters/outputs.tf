output "cluster_arns" {
  description = "List of ECS cluster ARNs associated with the account"
  value       = data.aws_ecs_clusters.this.cluster_arns
}