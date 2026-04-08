output "id" {
  description = "ID of the found API Gateway VPC Link."
  value       = data.aws_api_gateway_vpc_link.this.id
}

output "description" {
  description = "Description of the VPC link."
  value       = data.aws_api_gateway_vpc_link.this.description
}

output "status" {
  description = "Status of the VPC link."
  value       = data.aws_api_gateway_vpc_link.this.status
}

output "status_message" {
  description = "Status message of the VPC link."
  value       = data.aws_api_gateway_vpc_link.this.status_message
}

output "target_arns" {
  description = "List of network load balancer arns in the VPC targeted by the VPC link. Currently AWS only supports 1 target."
  value       = data.aws_api_gateway_vpc_link.this.target_arns
}

output "tags" {
  description = "Key-value map of resource tags."
  value       = data.aws_api_gateway_vpc_link.this.tags
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_api_gateway_vpc_link.this.region
}

output "name" {
  description = "Name of the API Gateway VPC Link."
  value       = data.aws_api_gateway_vpc_link.this.name
}