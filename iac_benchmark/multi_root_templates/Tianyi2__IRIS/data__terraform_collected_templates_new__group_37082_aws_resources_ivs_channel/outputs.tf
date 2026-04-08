output "arn" {
  description = "ARN of the Channel."
  value       = aws_ivs_channel.this.arn
}

output "ingest_endpoint" {
  description = "Channel ingest endpoint, part of the definition of an ingest server, used when setting up streaming software."
  value       = aws_ivs_channel.this.ingest_endpoint
}

output "playback_url" {
  description = "Channel playback URL."
  value       = aws_ivs_channel.this.playback_url
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ivs_channel.this.tags_all
}