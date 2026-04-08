output "created_at" {
  description = "Date and time when the deployment was created."
  value       = aws_lightsail_container_service_deployment_version.this.created_at
}

output "id" {
  description = "service_name and version separated by a slash (/)."
  value       = aws_lightsail_container_service_deployment_version.this.id
}

output "state" {
  description = "Current state of the container service."
  value       = aws_lightsail_container_service_deployment_version.this.state
}

output "version" {
  description = "Version number of the deployment."
  value       = aws_lightsail_container_service_deployment_version.this.version
}