output "arn" {
  description = "The Amazon Resource Name (ARN) of the discoverer."
  value       = aws_schemas_discoverer.this.arn
}

output "id" {
  description = "The ID of the discoverer."
  value       = aws_schemas_discoverer.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_schemas_discoverer.this.tags_all
}