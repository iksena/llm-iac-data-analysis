output "id" {
  description = "ARN of the Kinesis Firehose Delivery Stream"
  value       = data.aws_kinesis_firehose_delivery_stream.this.id
}

output "arn" {
  description = "ARN of the Kinesis Firehose Delivery Stream (same as id)"
  value       = data.aws_kinesis_firehose_delivery_stream.this.arn
}

output "name" {
  description = "Name of the Kinesis Firehose Delivery Stream"
  value       = data.aws_kinesis_firehose_delivery_stream.this.name
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_kinesis_firehose_delivery_stream.this.region
}