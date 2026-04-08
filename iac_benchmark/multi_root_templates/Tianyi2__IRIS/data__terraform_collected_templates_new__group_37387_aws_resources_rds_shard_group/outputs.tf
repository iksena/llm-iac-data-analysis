output "arn" {
  description = "ARN of the shard group."
  value       = aws_rds_shard_group.this.arn
}

output "db_shard_group_resource_id" {
  description = "The AWS Region-unique, immutable identifier for the DB shard group."
  value       = aws_rds_shard_group.this.db_shard_group_resource_id
}

output "endpoint" {
  description = "The connection endpoint for the DB shard group."
  value       = aws_rds_shard_group.this.endpoint
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_rds_shard_group.this.tags_all
}