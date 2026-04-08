output "environment_id" {
  description = "Environment to deploy application to."
  value       = aws_m2_deployment.this.environment_id
}

output "application_id" {
  description = "Application to deploy."
  value       = aws_m2_deployment.this.application_id
}

output "application_version" {
  description = "Version to application to deploy"
  value       = aws_m2_deployment.this.application_version
}

output "start" {
  description = "Start the application once deployed."
  value       = aws_m2_deployment.this.start
}

output "deployment_id" {
  description = "The deployment identifier."
  value       = aws_m2_deployment.this.id
}