output "arn" {
  description = "Amazon Resource Name (ARN) of cluster"
  value       = aws_docdb_cluster.this.arn
}

output "cluster_members" {
  description = "List of DocumentDB Instances that are a part of this cluster"
  value       = aws_docdb_cluster.this.cluster_members
}

output "cluster_resource_id" {
  description = "The DocumentDB Cluster Resource ID"
  value       = aws_docdb_cluster.this.cluster_resource_id
}

output "endpoint" {
  description = "The DNS address of the DocumentDB instance"
  value       = aws_docdb_cluster.this.endpoint
}

output "hosted_zone_id" {
  description = "The Route53 Hosted Zone ID of the endpoint"
  value       = aws_docdb_cluster.this.hosted_zone_id
}

output "id" {
  description = "(Deprecated) Amazon Resource Name (ARN) of cluster"
  value       = aws_docdb_cluster.this.id
}

output "reader_endpoint" {
  description = "A read-only endpoint for the DocumentDB cluster, automatically load-balanced across replicas"
  value       = aws_docdb_cluster.this.reader_endpoint
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_docdb_cluster.this.tags_all
}