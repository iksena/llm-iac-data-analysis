output "arn" {
  description = "ARN of the Sink."
  value       = aws_oam_sink_policy.this.arn
}

output "sink_id" {
  description = "ID string that AWS generated as part of the sink ARN."
  value       = aws_oam_sink_policy.this.sink_id
}