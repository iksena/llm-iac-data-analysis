output "id" {
  description = "Same as user_name"
  value       = aws_memorydb_user.this.id
}

output "arn" {
  description = "ARN of the user"
  value       = aws_memorydb_user.this.arn
}

output "minimum_engine_version" {
  description = "Minimum engine version supported for the user"
  value       = aws_memorydb_user.this.minimum_engine_version
}

output "authentication_mode" {
  description = "Authentication mode configuration including password_count"
  value       = aws_memorydb_user.this.authentication_mode
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_memorydb_user.this.tags_all
}