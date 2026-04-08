output "arn" {
  description = "ARN of the cluster."
  value       = aws_emrcontainers_virtual_cluster.this.arn
}

output "id" {
  description = "The ID of the cluster."
  value       = aws_emrcontainers_virtual_cluster.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_emrcontainers_virtual_cluster.this.tags_all
}