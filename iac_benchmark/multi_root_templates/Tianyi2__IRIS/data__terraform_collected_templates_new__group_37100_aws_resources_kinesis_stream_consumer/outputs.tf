output "arn" {
  description = "Amazon Resource Name (ARN) of the stream consumer."
  value       = aws_kinesis_stream_consumer.this.arn
}

output "creation_timestamp" {
  description = "Approximate timestamp in RFC3339 format of when the stream consumer was created."
  value       = aws_kinesis_stream_consumer.this.creation_timestamp
}

output "id" {
  description = "Amazon Resource Name (ARN) of the stream consumer."
  value       = aws_kinesis_stream_consumer.this.id
}