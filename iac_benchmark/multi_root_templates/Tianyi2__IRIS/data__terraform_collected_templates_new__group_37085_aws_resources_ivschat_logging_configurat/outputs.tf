output "arn" {
  description = "ARN of the Logging Configuration."
  value       = aws_ivschat_logging_configuration.this.arn
}

output "id" {
  description = "ID of the Logging Configuration."
  value       = aws_ivschat_logging_configuration.this.id
}

output "state" {
  description = "State of the Logging Configuration."
  value       = aws_ivschat_logging_configuration.this.state
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ivschat_logging_configuration.this.tags_all
}