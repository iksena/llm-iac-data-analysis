output "id" {
  description = "The docDB subnet group name."
  value       = aws_docdb_subnet_group.this.id
}

output "arn" {
  description = "The ARN of the docDB subnet group."
  value       = aws_docdb_subnet_group.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_docdb_subnet_group.this.tags_all
}