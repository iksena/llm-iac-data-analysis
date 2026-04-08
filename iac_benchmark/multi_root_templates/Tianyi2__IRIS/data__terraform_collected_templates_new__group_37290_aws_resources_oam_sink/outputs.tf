output "arn" {
  description = "ARN of the Sink."
  value       = aws_oam_sink.this.arn
}

output "id" {
  description = "ARN of the Sink. Use arn instead."
  value       = aws_oam_sink.this.id
}

output "sink_id" {
  description = "ID string that AWS generated as part of the sink ARN."
  value       = aws_oam_sink.this.sink_id
}