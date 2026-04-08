output "arn" {
  description = "The Amazon Resource Name (ARN) of the discoverer."
  value       = aws_schemas_registry.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_schemas_registry.this.tags_all
}

output "region" {
  description = "Region where this resource will be managed."
  value       = aws_schemas_registry.this.region
}

output "name" {
  description = "The name of the custom event schema registry."
  value       = aws_schemas_registry.this.name
}

output "description" {
  description = "The description of the discoverer."
  value       = aws_schemas_registry.this.description
}

output "tags" {
  description = "A map of tags to assign to the resource."
  value       = aws_schemas_registry.this.tags
}