output "arn" {
  description = "The Neptune Cluster Endpoint Amazon Resource Name (ARN)."
  value       = aws_neptune_cluster_endpoint.this.arn
}

output "endpoint" {
  description = "The DNS address of the endpoint."
  value       = aws_neptune_cluster_endpoint.this.endpoint
}

output "id" {
  description = "The Neptune Cluster Endpoint Identifier."
  value       = aws_neptune_cluster_endpoint.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_neptune_cluster_endpoint.this.tags_all
}