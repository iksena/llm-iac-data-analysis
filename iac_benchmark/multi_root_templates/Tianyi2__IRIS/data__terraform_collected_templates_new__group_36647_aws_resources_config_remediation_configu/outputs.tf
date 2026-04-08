output "arn" {
  description = "ARN of the Config Remediation Configuration"
  value       = aws_config_remediation_configuration.this.arn
}

output "config_rule_name" {
  description = "Name of the AWS Config rule"
  value       = aws_config_remediation_configuration.this.config_rule_name
}

output "target_id" {
  description = "Target ID is the name of the public document"
  value       = aws_config_remediation_configuration.this.target_id
}

output "target_type" {
  description = "Type of the target"
  value       = aws_config_remediation_configuration.this.target_type
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_config_remediation_configuration.this.region
}

output "automatic" {
  description = "Whether remediation is triggered automatically"
  value       = aws_config_remediation_configuration.this.automatic
}

output "maximum_automatic_attempts" {
  description = "Maximum number of failed attempts for auto-remediation"
  value       = aws_config_remediation_configuration.this.maximum_automatic_attempts
}

output "resource_type" {
  description = "Type of resource"
  value       = aws_config_remediation_configuration.this.resource_type
}

output "retry_attempt_seconds" {
  description = "Maximum time in seconds that AWS Config runs auto-remediation"
  value       = aws_config_remediation_configuration.this.retry_attempt_seconds
}

output "target_version" {
  description = "Version of the target"
  value       = aws_config_remediation_configuration.this.target_version
}

output "execution_controls" {
  description = "Configuration block for execution controls"
  value       = aws_config_remediation_configuration.this.execution_controls
}

output "parameters" {
  description = "List of parameter blocks"
  value       = aws_config_remediation_configuration.this.parameter
}