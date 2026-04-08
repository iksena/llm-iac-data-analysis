output "id" {
  description = "Same as name."
  value       = aws_memorydb_acl.this.id
}

output "arn" {
  description = "The ARN of the ACL."
  value       = aws_memorydb_acl.this.arn
}

output "minimum_engine_version" {
  description = "The minimum engine version supported by the ACL."
  value       = aws_memorydb_acl.this.minimum_engine_version
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_memorydb_acl.this.tags_all
}