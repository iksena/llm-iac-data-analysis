output "arn" {
  description = "The ARN of the channel"
  value       = aws_media_packagev2_channel_group.this.arn
}

output "description" {
  description = "The same as description"
  value       = aws_media_packagev2_channel_group.this.description
}

output "egress_domain" {
  description = "The egress domain of the channel group"
  value       = aws_media_packagev2_channel_group.this.egress_domain
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_media_packagev2_channel_group.this.tags_all
}