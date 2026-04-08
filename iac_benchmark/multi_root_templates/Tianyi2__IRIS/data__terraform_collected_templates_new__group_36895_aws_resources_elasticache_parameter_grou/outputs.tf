output "id" {
  description = "The ElastiCache parameter group name."
  value       = aws_elasticache_parameter_group.this.id
}

output "arn" {
  description = "The AWS ARN associated with the parameter group."
  value       = aws_elasticache_parameter_group.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_elasticache_parameter_group.this.tags_all
}