output "id" {
  description = "The application identifier."
  value       = aws_kinesisanalyticsv2_application.this.id
}

output "arn" {
  description = "The ARN of the application."
  value       = aws_kinesisanalyticsv2_application.this.arn
}

output "create_timestamp" {
  description = "The current timestamp when the application was created."
  value       = aws_kinesisanalyticsv2_application.this.create_timestamp
}

output "last_update_timestamp" {
  description = "The current timestamp when the application was last updated."
  value       = aws_kinesisanalyticsv2_application.this.last_update_timestamp
}

output "status" {
  description = "The status of the application."
  value       = aws_kinesisanalyticsv2_application.this.status
}

output "version_id" {
  description = "The current application version. Kinesis Data Analytics updates the version_id each time the application is updated."
  value       = aws_kinesisanalyticsv2_application.this.version_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_kinesisanalyticsv2_application.this.tags_all
}