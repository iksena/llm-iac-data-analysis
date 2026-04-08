output "arn" {
  description = "ARN of the Channel."
  value       = aws_medialive_channel.this.arn
}

output "channel_id" {
  description = "ID of the Channel."
  value       = aws_medialive_channel.this.channel_id
}