output "arn" {
  description = "ARN of the Recording Configuration"
  value       = aws_ivs_recording_configuration.this.arn
}

output "state" {
  description = "The current state of the Recording Configuration"
  value       = aws_ivs_recording_configuration.this.state
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_ivs_recording_configuration.this.tags_all
}

output "name" {
  description = "Recording Configuration name"
  value       = aws_ivs_recording_configuration.this.name
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_ivs_recording_configuration.this.region
}

output "recording_reconnect_window_seconds" {
  description = "Broadcast reconnection window in seconds"
  value       = aws_ivs_recording_configuration.this.recording_reconnect_window_seconds
}

output "destination_configuration" {
  description = "Destination configuration for where recorded video will be stored"
  value       = aws_ivs_recording_configuration.this.destination_configuration
}

output "thumbnail_configuration" {
  description = "Thumbnail configuration for the live session"
  value       = aws_ivs_recording_configuration.this.thumbnail_configuration
}