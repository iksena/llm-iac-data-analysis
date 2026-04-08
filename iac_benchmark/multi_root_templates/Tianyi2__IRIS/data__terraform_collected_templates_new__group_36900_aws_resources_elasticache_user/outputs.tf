output "access_string" {
  description = "Access permissions string used for this user"
  value       = aws_elasticache_user.this.access_string
}

output "engine" {
  description = "The engine type"
  value       = aws_elasticache_user.this.engine
}

output "user_id" {
  description = "The ID of the user"
  value       = aws_elasticache_user.this.user_id
}

output "user_name" {
  description = "The username of the user"
  value       = aws_elasticache_user.this.user_name
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_elasticache_user.this.region
}

output "authentication_mode" {
  description = "The user's authentication properties"
  value       = aws_elasticache_user.this.authentication_mode
}

output "no_password_required" {
  description = "Indicates if a password is not required for this user"
  value       = aws_elasticache_user.this.no_password_required
}

output "passwords" {
  description = "Passwords used for this user"
  value       = aws_elasticache_user.this.passwords
  sensitive   = true
}

output "tags" {
  description = "Tags applied to this resource"
  value       = aws_elasticache_user.this.tags
}

output "arn" {
  description = "The ARN of the created ElastiCache User"
  value       = aws_elasticache_user.this.arn
}