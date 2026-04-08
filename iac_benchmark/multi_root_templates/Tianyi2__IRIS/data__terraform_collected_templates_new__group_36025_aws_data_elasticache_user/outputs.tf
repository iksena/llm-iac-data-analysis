output "user_id" {
  description = "Identifier for the user."
  value       = data.aws_elasticache_user.this.user_id
}

output "user_name" {
  description = "User name of the user."
  value       = data.aws_elasticache_user.this.user_name
}

output "access_string" {
  description = "String for what access a user possesses within the associated ElastiCache replication groups or clusters."
  value       = data.aws_elasticache_user.this.access_string
}