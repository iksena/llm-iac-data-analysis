output "id" {
  description = "Same as name"
  value       = aws_memorydb_parameter_group.this.id
}

output "arn" {
  description = "The ARN of the parameter group"
  value       = aws_memorydb_parameter_group.this.arn
}

output "name" {
  description = "Name of the parameter group"
  value       = aws_memorydb_parameter_group.this.name
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_memorydb_parameter_group.this.tags_all
}