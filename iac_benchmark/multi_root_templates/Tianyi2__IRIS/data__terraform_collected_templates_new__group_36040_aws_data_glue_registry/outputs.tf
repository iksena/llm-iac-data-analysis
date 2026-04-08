output "arn" {
  description = "Amazon Resource Name (ARN) of Glue Registry"
  value       = data.aws_glue_registry.this.arn
}

output "description" {
  description = "A description of the registry"
  value       = data.aws_glue_registry.this.description
}