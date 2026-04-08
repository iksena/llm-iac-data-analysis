output "region" {
  description = "Region where this resource is managed."
  value       = aws_pinpoint_event_stream.this.region
}

output "application_id" {
  description = "The application ID."
  value       = aws_pinpoint_event_stream.this.application_id
}

output "destination_stream_arn" {
  description = "The Amazon Resource Name (ARN) of the Amazon Kinesis stream or Firehose delivery stream to which events are published."
  value       = aws_pinpoint_event_stream.this.destination_stream_arn
}

output "role_arn" {
  description = "The IAM role that authorizes Amazon Pinpoint to publish events to the stream."
  value       = aws_pinpoint_event_stream.this.role_arn
}