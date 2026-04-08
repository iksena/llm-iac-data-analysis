output "id" {
  description = "AWS Region in which logging is configured"
  value       = aws_bedrock_model_invocation_logging_configuration.this.id
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_bedrock_model_invocation_logging_configuration.this.region
}

output "logging_config" {
  description = "The logging configuration values"
  value       = aws_bedrock_model_invocation_logging_configuration.this.logging_config
}