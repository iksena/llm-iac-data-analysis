output "id" {
  description = "The same as channel_id"
  value       = aws_media_package_channel.this.id
}

output "arn" {
  description = "The ARN of the channel"
  value       = aws_media_package_channel.this.arn
}

output "hls_ingest" {
  description = "A single item list of HLS ingest information"
  value       = aws_media_package_channel.this.hls_ingest
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_media_package_channel.this.tags_all
}