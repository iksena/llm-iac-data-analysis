output "id" {
  description = "The name of the keyspace."
  value       = aws_keyspaces_keyspace.this.id
}

output "arn" {
  description = "The ARN of the keyspace."
  value       = aws_keyspaces_keyspace.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_keyspaces_keyspace.this.tags_all
}