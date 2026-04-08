output "arn" {
  description = "The Amazon Resource Name (ARN) of the delivery destination."
  value       = aws_cloudwatch_log_delivery_destination.this.arn
}

output "delivery_destination_type" {
  description = "Whether this delivery destination is CloudWatch Logs, Amazon S3, or Firehose."
  value       = aws_cloudwatch_log_delivery_destination.this.delivery_destination_type
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_cloudwatch_log_delivery_destination.this.tags_all
}