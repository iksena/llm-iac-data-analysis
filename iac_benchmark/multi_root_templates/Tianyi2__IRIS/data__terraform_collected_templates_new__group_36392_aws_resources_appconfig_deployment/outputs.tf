output "id" {
  description = "AppConfig application ID, environment ID, and deployment number separated by a slash (/)."
  value       = aws_appconfig_deployment.this.id
}

output "arn" {
  description = "ARN of the AppConfig Deployment."
  value       = aws_appconfig_deployment.this.arn
}

output "deployment_number" {
  description = "Deployment number."
  value       = aws_appconfig_deployment.this.deployment_number
}

output "kms_key_arn" {
  description = "ARN of the KMS key used to encrypt configuration data."
  value       = aws_appconfig_deployment.this.kms_key_arn
}

output "state" {
  description = "State of the deployment."
  value       = aws_appconfig_deployment.this.state
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_appconfig_deployment.this.tags_all
}