output "id" {
  description = "The ID of the IoT logging options resource"
  value       = aws_iot_logging_options.this.id
}

output "region" {
  description = "The region where the IoT logging options are configured"
  value       = aws_iot_logging_options.this.region
}

output "default_log_level" {
  description = "The default logging level"
  value       = aws_iot_logging_options.this.default_log_level
}

output "disable_all_logs" {
  description = "Whether all logs are disabled"
  value       = aws_iot_logging_options.this.disable_all_logs
}

output "role_arn" {
  description = "The ARN of the role that allows IoT to write to Cloudwatch logs"
  value       = aws_iot_logging_options.this.role_arn
}