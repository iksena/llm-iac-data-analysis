output "arn" {
  description = "ARN of the code signing configuration."
  value       = aws_lambda_code_signing_config.this.arn
}

output "config_id" {
  description = "Unique identifier for the code signing configuration."
  value       = aws_lambda_code_signing_config.this.config_id
}

output "last_modified" {
  description = "Date and time that the code signing configuration was last modified."
  value       = aws_lambda_code_signing_config.this.last_modified
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_lambda_code_signing_config.this.tags_all
}