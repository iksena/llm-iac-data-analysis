output "id" {
  description = "The DocumentDB cluster parameter group name."
  value       = aws_docdb_cluster_parameter_group.this.id
}

output "arn" {
  description = "The ARN of the DocumentDB cluster parameter group."
  value       = aws_docdb_cluster_parameter_group.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_docdb_cluster_parameter_group.this.tags_all
}