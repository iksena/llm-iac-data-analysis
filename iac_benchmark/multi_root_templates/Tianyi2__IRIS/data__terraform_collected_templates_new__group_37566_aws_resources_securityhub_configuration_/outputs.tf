output "id" {
  description = "The UUID of the configuration policy"
  value       = aws_securityhub_configuration_policy.this.id
}

output "arn" {
  description = "The ARN of the configuration policy"
  value       = aws_securityhub_configuration_policy.this.arn
}

output "name" {
  description = "The name of the configuration policy"
  value       = aws_securityhub_configuration_policy.this.name
}

output "description" {
  description = "The description of the configuration policy"
  value       = aws_securityhub_configuration_policy.this.description
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_securityhub_configuration_policy.this.region
}

output "configuration_policy" {
  description = "The configuration policy settings"
  value       = aws_securityhub_configuration_policy.this.configuration_policy
}