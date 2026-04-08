output "id" {
  description = "Identifier of the VpcLink."
  value       = aws_api_gateway_vpc_link.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_api_gateway_vpc_link.this.tags_all
}

output "region" {
  description = "Region where this resource will be managed."
  value       = aws_api_gateway_vpc_link.this.region
}

output "name" {
  description = "Name used to label and identify the VPC link."
  value       = aws_api_gateway_vpc_link.this.name
}

output "description" {
  description = "Description of the VPC link."
  value       = aws_api_gateway_vpc_link.this.description
}

output "target_arns" {
  description = "List of network load balancer arns in the VPC targeted by the VPC link."
  value       = aws_api_gateway_vpc_link.this.target_arns
}

output "tags" {
  description = "Key-value map of resource tags."
  value       = aws_api_gateway_vpc_link.this.tags
}