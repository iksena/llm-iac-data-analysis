output "id" {
  description = "Name of the data catalog."
  value       = aws_athena_data_catalog.this.id
}

output "arn" {
  description = "ARN of the data catalog."
  value       = aws_athena_data_catalog.this.arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_athena_data_catalog.this.tags_all
}