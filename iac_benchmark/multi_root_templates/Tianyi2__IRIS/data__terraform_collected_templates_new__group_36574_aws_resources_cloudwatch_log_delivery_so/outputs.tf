output "arn" {
  description = "The Amazon Resource Name (ARN) of the delivery source."
  value       = aws_cloudwatch_log_delivery_source.this.arn
}

output "service" {
  description = "The AWS service that is sending logs."
  value       = aws_cloudwatch_log_delivery_source.this.service
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_cloudwatch_log_delivery_source.this.tags_all
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_cloudwatch_log_delivery_source.this.region
}

output "log_type" {
  description = "The type of log that the source is sending."
  value       = aws_cloudwatch_log_delivery_source.this.log_type
}

output "name" {
  description = "The name for this delivery source."
  value       = aws_cloudwatch_log_delivery_source.this.name
}

output "resource_arn" {
  description = "The ARN of the AWS resource that is generating and sending logs."
  value       = aws_cloudwatch_log_delivery_source.this.resource_arn
}

output "tags" {
  description = "A map of tags assigned to the resource."
  value       = aws_cloudwatch_log_delivery_source.this.tags
}