output "arn" {
  description = "Amazon Resource Name (ARN) of cluster"
  value       = aws_rds_cluster_endpoint.this.arn
}

output "id" {
  description = "The RDS Cluster Endpoint Identifier"
  value       = aws_rds_cluster_endpoint.this.id
}

output "endpoint" {
  description = "A custom endpoint for the Aurora cluster"
  value       = aws_rds_cluster_endpoint.this.endpoint
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_rds_cluster_endpoint.this.tags_all
}