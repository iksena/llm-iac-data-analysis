output "arn" {
  description = "ARN of the Service Network."
  value       = data.aws_vpclattice_service_network.this.arn
}

output "auth_type" {
  description = "Authentication type for the service network. Either NONE or AWS_IAM."
  value       = data.aws_vpclattice_service_network.this.auth_type
}

output "created_at" {
  description = "Date and time the service network was created."
  value       = data.aws_vpclattice_service_network.this.created_at
}

output "id" {
  description = "ID of the service network."
  value       = data.aws_vpclattice_service_network.this.id
}

output "last_updated_at" {
  description = "Date and time the service network was last updated."
  value       = data.aws_vpclattice_service_network.this.last_updated_at
}

output "name" {
  description = "Name of the service network."
  value       = data.aws_vpclattice_service_network.this.name
}

output "number_of_associated_services" {
  description = "Number of services associated with this service network."
  value       = data.aws_vpclattice_service_network.this.number_of_associated_services
}

output "number_of_associated_vpcs" {
  description = "Number of VPCs associated with this service network."
  value       = data.aws_vpclattice_service_network.this.number_of_associated_vpcs
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_vpclattice_service_network.this.region
}

output "service_network_identifier" {
  description = "Identifier of the service network."
  value       = data.aws_vpclattice_service_network.this.service_network_identifier
}