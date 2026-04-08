output "arn" {
  description = "ARN of the container service."
  value       = aws_lightsail_container_service.this.arn
}

output "availability_zone" {
  description = "Availability Zone. Follows the format us-east-2a (case-sensitive)."
  value       = aws_lightsail_container_service.this.availability_zone
}

output "created_at" {
  description = "Date and time when the container service was created."
  value       = aws_lightsail_container_service.this.created_at
}

output "id" {
  description = "Same as name."
  value       = aws_lightsail_container_service.this.id
}

output "power_id" {
  description = "Power ID of the container service."
  value       = aws_lightsail_container_service.this.power_id
}

output "principal_arn" {
  description = "Principal ARN of the container service. The principal ARN can be used to create a trust relationship between your standard AWS account and your Lightsail container service."
  value       = aws_lightsail_container_service.this.principal_arn
}

output "private_domain_name" {
  description = "Private domain name of the container service. The private domain name is accessible only by other resources within the default virtual private cloud (VPC) of your Lightsail account."
  value       = aws_lightsail_container_service.this.private_domain_name
}

output "private_registry_access" {
  description = "Configuration for the container service to access private container image repositories."
  value       = aws_lightsail_container_service.this.private_registry_access
}

output "region_name" {
  description = "AWS Region name."
  value       = var.region
}

output "resource_type" {
  description = "Lightsail resource type of the container service (i.e., ContainerService)."
  value       = aws_lightsail_container_service.this.resource_type
}

output "state" {
  description = "Current state of the container service."
  value       = aws_lightsail_container_service.this.state
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_lightsail_container_service.this.tags_all
}

output "url" {
  description = "Publicly accessible URL of the container service. If no public endpoint is specified in the currentDeployment, this URL returns a 404 response."
  value       = aws_lightsail_container_service.this.url
}