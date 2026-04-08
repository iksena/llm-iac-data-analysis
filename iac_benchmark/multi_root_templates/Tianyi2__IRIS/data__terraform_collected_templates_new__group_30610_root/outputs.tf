output "arn" {
  description = "The Amazon Resource Name (ARN) of the Kinesis Firehouse"
  value       = try(aws_kinesis_firehose_delivery_stream.this[0].arn, null)
}
