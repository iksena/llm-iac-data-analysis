output "arn" {
  description = "Neptune Cluster ARN"
  value       = aws_neptune_cluster.this.arn
}

output "cluster_resource_id" {
  description = "Neptune Cluster Resource ID"
  value       = aws_neptune_cluster.this.cluster_resource_id
}

output "cluster_members" {
  description = "List of Neptune Instances that are a part of this cluster"
  value       = aws_neptune_cluster.this.cluster_members
}

output "endpoint" {
  description = "DNS address of the Neptune instance"
  value       = aws_neptune_cluster.this.endpoint
}

output "hosted_zone_id" {
  description = "Route53 Hosted Zone ID of the endpoint"
  value       = aws_neptune_cluster.this.hosted_zone_id
}

output "id" {
  description = "Neptune Cluster Identifier"
  value       = aws_neptune_cluster.this.id
}

output "reader_endpoint" {
  description = "Read-only endpoint for the Neptune cluster, automatically load-balanced across replicas"
  value       = aws_neptune_cluster.this.reader_endpoint
}


output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_neptune_cluster.this.tags_all
}