output "arn" {
  description = "ARN of the configuration"
  value       = aws_mq_configuration.this.arn
}

output "id" {
  description = "Unique ID that Amazon MQ generates for the configuration"
  value       = aws_mq_configuration.this.id
}

output "latest_revision" {
  description = "Latest revision of the configuration"
  value       = aws_mq_configuration.this.latest_revision
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_mq_configuration.this.tags_all
}