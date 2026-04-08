output "arn" {
  description = "The ARN of the multi-region cluster."
  value       = aws_memorydb_multi_region_cluster.this.arn
}

output "multi_region_cluster_name" {
  description = "The name of the multi-region cluster."
  value       = aws_memorydb_multi_region_cluster.this.multi_region_cluster_name
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_memorydb_multi_region_cluster.this.tags_all
}