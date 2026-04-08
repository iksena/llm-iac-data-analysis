output "arn" {
  description = "The Amazon Resource Name (ARN) of the discoverer."
  value       = aws_schemas_schema.this.arn
}

output "last_modified" {
  description = "The last modified date of the schema."
  value       = aws_schemas_schema.this.last_modified
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_schemas_schema.this.tags_all
}

output "version" {
  description = "The version of the schema."
  value       = aws_schemas_schema.this.version
}

output "version_created_date" {
  description = "The created date of the version of the schema."
  value       = aws_schemas_schema.this.version_created_date
}