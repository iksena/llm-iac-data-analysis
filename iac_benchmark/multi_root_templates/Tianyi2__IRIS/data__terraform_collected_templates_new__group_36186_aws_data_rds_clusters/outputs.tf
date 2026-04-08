output "cluster_arns" {
  description = "Set of cluster ARNs of the matched RDS clusters"
  value       = data.aws_rds_clusters.this.cluster_arns
}

output "cluster_identifiers" {
  description = "Set of ARNs of cluster identifiers of the matched RDS clusters"
  value       = data.aws_rds_clusters.this.cluster_identifiers
}

output "region" {
  description = "Region where this resource will be managed"
  value       = data.aws_rds_clusters.this.region
}

output "filter" {
  description = "Configuration block(s) for filtering"
  value       = var.filter
}