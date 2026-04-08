output "arn" {
  description = "ARN for a backend environment that is part of an Amplify app."
  value       = aws_amplify_backend_environment.this.arn
}

output "id" {
  description = "Unique ID of the Amplify backend environment."
  value       = aws_amplify_backend_environment.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_amplify_backend_environment.this.region
}

output "app_id" {
  description = "Unique ID for an Amplify app."
  value       = aws_amplify_backend_environment.this.app_id
}

output "environment_name" {
  description = "Name for the backend environment."
  value       = aws_amplify_backend_environment.this.environment_name
}

output "deployment_artifacts" {
  description = "Name of deployment artifacts."
  value       = aws_amplify_backend_environment.this.deployment_artifacts
}

output "stack_name" {
  description = "AWS CloudFormation stack name of a backend environment."
  value       = aws_amplify_backend_environment.this.stack_name
}