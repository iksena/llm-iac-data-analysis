output "id" {
  description = "The user group identifier"
  value       = aws_elasticache_user_group.this.id
}

output "arn" {
  description = "The ARN that identifies the user group"
  value       = aws_elasticache_user_group.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_elasticache_user_group.this.tags_all
}