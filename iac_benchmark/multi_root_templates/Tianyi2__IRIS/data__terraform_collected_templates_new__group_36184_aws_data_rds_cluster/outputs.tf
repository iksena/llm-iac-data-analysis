output "cluster_identifier" {
  description = "The RDS cluster identifier"
  value       = data.aws_rds_cluster.this.cluster_identifier
}

output "region" {
  description = "The AWS region of the cluster"
  value       = data.aws_rds_cluster.this.region
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = data.aws_rds_cluster.this.tags
}