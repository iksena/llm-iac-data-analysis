output "arn" {
  description = "ARN of the Stream Key."
  value       = data.aws_ivs_stream_key.this.arn
}

output "tags" {
  description = "Map of tags assigned to the resource."
  value       = data.aws_ivs_stream_key.this.tags
}

output "value" {
  description = "Stream Key value."
  value       = data.aws_ivs_stream_key.this.value
  sensitive   = true
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_ivs_stream_key.this.region
}

output "channel_arn" {
  description = "ARN of the Channel."
  value       = data.aws_ivs_stream_key.this.channel_arn
}