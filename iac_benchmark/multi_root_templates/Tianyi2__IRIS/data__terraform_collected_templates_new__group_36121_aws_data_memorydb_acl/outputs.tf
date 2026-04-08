output "id" {
  description = "Name of the ACL"
  value       = data.aws_memorydb_acl.this.id
}

output "arn" {
  description = "ARN of the ACL"
  value       = data.aws_memorydb_acl.this.arn
}

output "minimum_engine_version" {
  description = "The minimum engine version supported by the ACL"
  value       = data.aws_memorydb_acl.this.minimum_engine_version
}

output "tags" {
  description = "Map of tags assigned to the ACL"
  value       = data.aws_memorydb_acl.this.tags
}

output "user_names" {
  description = "Set of MemoryDB user names included in this ACL"
  value       = data.aws_memorydb_acl.this.user_names
}