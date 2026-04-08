output "arn" {
  description = "The ARN of the MWAA Environment"
  value       = aws_mwaa_environment.this.arn
}

output "created_at" {
  description = "The Created At date of the MWAA Environment"
  value       = aws_mwaa_environment.this.created_at
}

output "database_vpc_endpoint_service" {
  description = "The VPC endpoint for the environment's Amazon RDS database"
  value       = aws_mwaa_environment.this.database_vpc_endpoint_service
}

output "service_role_arn" {
  description = "The Service Role ARN of the Amazon MWAA Environment"
  value       = aws_mwaa_environment.this.service_role_arn
}

output "status" {
  description = "The status of the Amazon MWAA Environment"
  value       = aws_mwaa_environment.this.status
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_mwaa_environment.this.tags_all
}

output "webserver_url" {
  description = "The webserver URL of the MWAA Environment"
  value       = aws_mwaa_environment.this.webserver_url
}

output "webserver_vpc_endpoint_service" {
  description = "The VPC endpoint for the environment's web server"
  value       = aws_mwaa_environment.this.webserver_vpc_endpoint_service
}

output "dag_processing_logs_cloudwatch_log_group_arn" {
  description = "The ARN for the CloudWatch group where the DAG processing logs will be published"
  value       = try(aws_mwaa_environment.this.logging_configuration[0].dag_processing_logs[0].cloud_watch_log_group_arn, null)
}

output "scheduler_logs_cloudwatch_log_group_arn" {
  description = "The ARN for the CloudWatch group where the scheduler logs will be published"
  value       = try(aws_mwaa_environment.this.logging_configuration[0].scheduler_logs[0].cloud_watch_log_group_arn, null)
}

output "task_logs_cloudwatch_log_group_arn" {
  description = "The ARN for the CloudWatch group where the task logs will be published"
  value       = try(aws_mwaa_environment.this.logging_configuration[0].task_logs[0].cloud_watch_log_group_arn, null)
}

output "webserver_logs_cloudwatch_log_group_arn" {
  description = "The ARN for the CloudWatch group where the webserver logs will be published"
  value       = try(aws_mwaa_environment.this.logging_configuration[0].webserver_logs[0].cloud_watch_log_group_arn, null)
}

output "worker_logs_cloudwatch_log_group_arn" {
  description = "The ARN for the CloudWatch group where the worker logs will be published"
  value       = try(aws_mwaa_environment.this.logging_configuration[0].worker_logs[0].cloud_watch_log_group_arn, null)
}