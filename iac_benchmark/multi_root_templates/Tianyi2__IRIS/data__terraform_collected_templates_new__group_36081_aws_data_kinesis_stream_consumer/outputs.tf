output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_kinesis_stream_consumer.this.region
}

output "arn" {
  description = "ARN of the stream consumer."
  value       = data.aws_kinesis_stream_consumer.this.arn
}

output "name" {
  description = "Name of the stream consumer."
  value       = data.aws_kinesis_stream_consumer.this.name
}

output "stream_arn" {
  description = "ARN of the data stream the consumer is registered with."
  value       = data.aws_kinesis_stream_consumer.this.stream_arn
}

output "creation_timestamp" {
  description = "Approximate timestamp in RFC3339 format of when the stream consumer was created."
  value       = data.aws_kinesis_stream_consumer.this.creation_timestamp
}

output "id" {
  description = "ARN of the stream consumer."
  value       = data.aws_kinesis_stream_consumer.this.id
}

output "status" {
  description = "Current status of the stream consumer."
  value       = data.aws_kinesis_stream_consumer.this.status
}