output "id" {
  description = "Name of the user."
  value       = data.aws_memorydb_user.this.id
}

output "access_string" {
  description = "Access permissions string used for this user."
  value       = data.aws_memorydb_user.this.access_string
}

output "arn" {
  description = "ARN of the user."
  value       = data.aws_memorydb_user.this.arn
}

output "authentication_mode" {
  description = "Denotes the user's authentication properties."
  value       = data.aws_memorydb_user.this.authentication_mode
}

output "minimum_engine_version" {
  description = "Minimum engine version supported for the user."
  value       = data.aws_memorydb_user.this.minimum_engine_version
}

output "tags" {
  description = "Map of tags assigned to the user."
  value       = data.aws_memorydb_user.this.tags
}