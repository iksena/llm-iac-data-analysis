output "id" {
  description = "The ARN of the Kinesis Analytics Application."
  value       = aws_kinesis_analytics_application.this.id
}

output "arn" {
  description = "The ARN of the Kinesis Analytics Application."
  value       = aws_kinesis_analytics_application.this.arn
}

output "create_timestamp" {
  description = "The Timestamp when the application version was created."
  value       = aws_kinesis_analytics_application.this.create_timestamp
}

output "last_update_timestamp" {
  description = "The Timestamp when the application was last updated."
  value       = aws_kinesis_analytics_application.this.last_update_timestamp
}

output "status" {
  description = "The Status of the application."
  value       = aws_kinesis_analytics_application.this.status
}

output "version" {
  description = "The Version of the application."
  value       = aws_kinesis_analytics_application.this.version
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_kinesis_analytics_application.this.tags_all
}