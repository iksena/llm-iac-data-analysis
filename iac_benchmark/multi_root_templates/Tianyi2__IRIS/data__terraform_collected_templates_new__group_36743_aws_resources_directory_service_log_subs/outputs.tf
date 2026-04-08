output "directory_id" {
  description = "ID of directory."
  value       = aws_directory_service_log_subscription.this.directory_id
}

output "log_group_name" {
  description = "Name of the cloudwatch log group to which the logs are published."
  value       = aws_directory_service_log_subscription.this.log_group_name
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_directory_service_log_subscription.this.region
}