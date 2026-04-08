output "arn" {
  description = "The Amazon Resource Name (ARN) specifying the Stream"
  value       = aws_kinesis_firehose_delivery_stream.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_kinesis_firehose_delivery_stream.this.tags_all
}