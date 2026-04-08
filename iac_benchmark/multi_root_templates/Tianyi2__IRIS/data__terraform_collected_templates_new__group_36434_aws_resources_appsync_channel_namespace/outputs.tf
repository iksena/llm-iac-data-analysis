output "channel_namespace_arn" {
  description = "ARN of the channel namespace"
  value       = aws_appsync_channel_namespace.this.channel_namespace_arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_appsync_channel_namespace.this.tags_all
}