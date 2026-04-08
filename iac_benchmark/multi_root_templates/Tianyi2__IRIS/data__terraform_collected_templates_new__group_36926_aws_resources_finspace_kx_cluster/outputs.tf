output "arn" {
  description = "Amazon Resource Name (ARN) identifier of the KX cluster"
  value       = aws_finspace_kx_cluster.this.arn
}

output "created_timestamp" {
  description = "Timestamp at which the cluster is created in FinSpace. Value determined as epoch time in seconds"
  value       = aws_finspace_kx_cluster.this.created_timestamp
}

output "id" {
  description = "A comma-delimited string joining environment ID and cluster name"
  value       = aws_finspace_kx_cluster.this.id
}

output "last_modified_timestamp" {
  description = "Last timestamp at which the cluster was updated in FinSpace. Value determined as epoch time in seconds"
  value       = aws_finspace_kx_cluster.this.last_modified_timestamp
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_finspace_kx_cluster.this.tags_all
}