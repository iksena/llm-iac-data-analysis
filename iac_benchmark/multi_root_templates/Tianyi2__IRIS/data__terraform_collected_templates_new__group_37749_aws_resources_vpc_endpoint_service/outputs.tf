output "id" {
  description = "The ID of the VPC endpoint service."
  value       = aws_vpc_endpoint_service.this.id
}

output "availability_zones" {
  description = "A set of Availability Zones in which the service is available."
  value       = aws_vpc_endpoint_service.this.availability_zones
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of the VPC endpoint service."
  value       = aws_vpc_endpoint_service.this.arn
}

output "base_endpoint_dns_names" {
  description = "A set of DNS names for the service."
  value       = aws_vpc_endpoint_service.this.base_endpoint_dns_names
}

output "manages_vpc_endpoints" {
  description = "Whether or not the service manages its VPC endpoints - true or false."
  value       = aws_vpc_endpoint_service.this.manages_vpc_endpoints
}

output "service_name" {
  description = "The service name."
  value       = aws_vpc_endpoint_service.this.service_name
}

output "service_type" {
  description = "The service type, Gateway or Interface."
  value       = aws_vpc_endpoint_service.this.service_type
}

output "state" {
  description = "The state of the VPC endpoint service."
  value       = aws_vpc_endpoint_service.this.state
}

output "private_dns_name_configuration" {
  description = "List of objects containing information about the endpoint service private DNS name configuration."
  value       = aws_vpc_endpoint_service.this.private_dns_name_configuration
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_vpc_endpoint_service.this.tags_all
}