output "id" {
  description = "The ElastiCache user group association identifier."
  value       = aws_elasticache_user_group_association.this.id
}

output "user_group_id" {
  description = "ID of the user group."
  value       = aws_elasticache_user_group_association.this.user_group_id
}

output "user_id" {
  description = "ID of the user associated with the user group."
  value       = aws_elasticache_user_group_association.this.user_id
}