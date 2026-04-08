output "acceptance_required" {
  description = "Whether or not VPC endpoint connection requests to the service must be accepted by the service owner - true or false."
  value       = try(data.aws_vpc_endpoint_service.this[0].acceptance_required, null)
}

output "arn" {
  description = "ARN of the VPC endpoint service."
  value       = try(data.aws_vpc_endpoint_service.this[0].arn, null)
}

output "availability_zones" {
  description = "Availability Zones in which the service is available. Not available for endpoint services in other regions."
  value       = try(data.aws_vpc_endpoint_service.this[0].availability_zones, null)
}

output "base_endpoint_dns_names" {
  description = "The DNS names for the service."
  value       = try(data.aws_vpc_endpoint_service.this[0].base_endpoint_dns_names, null)
}

output "filter" {
  description = "Configuration block(s) for filtering."
  value       = try(data.aws_vpc_endpoint_service.this[0].filter, null)
}

output "manages_vpc_endpoints" {
  description = "Whether or not the service manages its VPC endpoints - true or false."
  value       = try(data.aws_vpc_endpoint_service.this[0].manages_vpc_endpoints, null)
}

output "owner" {
  description = "AWS account ID of the service owner or amazon."
  value       = try(data.aws_vpc_endpoint_service.this[0].owner, null)
}

output "private_dns_name" {
  description = "Private DNS name for the service."
  value       = try(data.aws_vpc_endpoint_service.this[0].private_dns_name, null)
}

output "private_dns_names" {
  description = "Private DNS names assigned to the VPC endpoint service."
  value       = try(data.aws_vpc_endpoint_service.this[0].private_dns_names, null)
}

output "region" {
  description = "Region of the endpoint service (deprecated - use service_region instead)."
  value       = try(data.aws_vpc_endpoint_service.this[0].region, null)
}

output "service" {
  description = "Common name of an AWS service (e.g., s3)."
  value       = try(data.aws_vpc_endpoint_service.this[0].service, null)
}

output "service_id" {
  description = "ID of the endpoint service."
  value       = try(data.aws_vpc_endpoint_service.this[0].service_id, null)
}

output "service_name" {
  description = "Service name that is specified when creating a VPC endpoint."
  value       = try(data.aws_vpc_endpoint_service.this[0].service_name, null)
}

output "service_region" {
  description = "Region of the endpoint service."
  value       = try(data.aws_vpc_endpoint_service.this[0].service_region, null)
}

output "service_regions" {
  description = "AWS regions in which to look for services."
  value       = try(data.aws_vpc_endpoint_service.this[0].service_regions, null)
}

output "service_type" {
  description = "Service type, Gateway or Interface."
  value       = try(data.aws_vpc_endpoint_service.this[0].service_type, null)
}

output "supported_ip_address_types" {
  description = "The supported IP address types."
  value       = try(data.aws_vpc_endpoint_service.this[0].supported_ip_address_types, null)
}

output "tags" {
  description = "Map of tags assigned to the resource."
  value       = try(data.aws_vpc_endpoint_service.this[0].tags, null)
}

output "vpc_endpoint_policy_supported" {
  description = "Whether or not the service supports endpoint policies - true or false."
  value       = try(data.aws_vpc_endpoint_service.this[0].vpc_endpoint_policy_supported, null)
}