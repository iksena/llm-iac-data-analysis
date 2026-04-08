output "arn" {
  description = "The ARN of the CloudWatch Metric Alarm"
  value       = aws_cloudwatch_metric_alarm.this.arn
}

output "id" {
  description = "The ID of the health check"
  value       = aws_cloudwatch_metric_alarm.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_cloudwatch_metric_alarm.this.tags_all
}