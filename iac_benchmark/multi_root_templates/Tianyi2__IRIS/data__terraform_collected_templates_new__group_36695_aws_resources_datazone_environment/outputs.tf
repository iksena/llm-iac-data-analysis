output "created_at" {
  description = "The time the environment was created"
  value       = aws_datazone_environment.this.created_at
}

output "created_by" {
  description = "The user who created the environment"
  value       = aws_datazone_environment.this.created_by
}

output "id" {
  description = "The ID of the environment"
  value       = aws_datazone_environment.this.id
}

output "last_deployment" {
  description = "The details of the last deployment of the environment"
  value       = aws_datazone_environment.this.last_deployment
}

output "provider_environment" {
  description = "The provider of the environment"
  value       = aws_datazone_environment.this.provider_environment
}

output "provisioned_resource" {
  description = "The provisioned resources of this environment"
  value       = aws_datazone_environment.this.provisioned_resources
}