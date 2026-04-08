output "arn" {
  value       = aws_rds_global_cluster.this.arn
  description = "RDS Global Cluster Amazon Resource Name (ARN)."
}

output "endpoint" {
  value       = aws_rds_global_cluster.this.endpoint
  description = "Writer endpoint for the new global database cluster. This endpoint always points to the writer DB instance in the current primary cluster."
}

output "global_cluster_members" {
  value       = aws_rds_global_cluster.this.global_cluster_members
  description = "Set of objects containing Global Cluster members."
}

output "global_cluster_resource_id" {
  value       = aws_rds_global_cluster.this.global_cluster_resource_id
  description = "AWS Region-unique, immutable identifier for the global database cluster. This identifier is found in AWS CloudTrail log entries whenever the AWS KMS key for the DB cluster is accessed."
}

output "id" {
  value       = aws_rds_global_cluster.this.id
  description = "RDS Global Cluster identifier."
}

output "tags_all" {
  value       = aws_rds_global_cluster.this.tags_all
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
}