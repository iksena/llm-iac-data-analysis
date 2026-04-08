output "arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this monitoring schedule."
  value       = aws_sagemaker_monitoring_schedule.this.arn
}

output "name" {
  description = "The name of the monitoring schedule."
  value       = aws_sagemaker_monitoring_schedule.this.name
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_sagemaker_monitoring_schedule.this.tags_all
}