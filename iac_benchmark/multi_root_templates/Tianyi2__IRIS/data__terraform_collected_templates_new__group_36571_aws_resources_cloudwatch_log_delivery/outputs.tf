output "arn" {
  description = "The Amazon Resource Name (ARN) of the delivery."
  value       = aws_cloudwatch_log_delivery.this.arn
}

output "id" {
  description = "The unique ID that identifies this delivery in your account."
  value       = aws_cloudwatch_log_delivery.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_cloudwatch_log_delivery.this.tags_all
}