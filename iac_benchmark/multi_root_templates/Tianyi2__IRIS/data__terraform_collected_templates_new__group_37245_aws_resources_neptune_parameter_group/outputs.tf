output "id" {
  description = "The Neptune parameter group name."
  value       = aws_neptune_parameter_group.this.id
}

output "arn" {
  description = "The Neptune parameter group Amazon Resource Name (ARN)."
  value       = aws_neptune_parameter_group.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_neptune_parameter_group.this.tags_all
}