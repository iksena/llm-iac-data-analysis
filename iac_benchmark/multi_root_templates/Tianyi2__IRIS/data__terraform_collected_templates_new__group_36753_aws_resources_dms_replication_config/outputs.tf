output "arn" {
  description = "The Amazon Resource Name (ARN) for the serverless replication config"
  value       = aws_dms_replication_config.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_dms_replication_config.this.tags_all
}