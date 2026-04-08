output "id" {
  description = "ID of the Route Table"
  value       = data.aws_route_table.this.id
}

output "arn" {
  description = "ARN of the route table"
  value       = data.aws_route_table.this.arn
}

output "owner_id" {
  description = "ID of the AWS account that owns the route table"
  value       = data.aws_route_table.this.owner_id
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_route_table.this.region
}

output "gateway_id" {
  description = "ID of an Internet Gateway or Virtual Private Gateway which is connected to the Route Table"
  value       = data.aws_route_table.this.gateway_id
}

output "route_table_id" {
  description = "ID of the specific Route Table"
  value       = data.aws_route_table.this.route_table_id
}

output "subnet_id" {
  description = "ID of a Subnet which is connected to the Route Table"
  value       = data.aws_route_table.this.subnet_id
}

output "tags" {
  description = "Map of tags on the Route Table"
  value       = data.aws_route_table.this.tags
}

output "vpc_id" {
  description = "ID of the VPC that the Route Table belongs to"
  value       = data.aws_route_table.this.vpc_id
}

output "associations" {
  description = "List of associations with detailed attributes"
  value       = data.aws_route_table.this.associations
}

output "routes" {
  description = "List of routes with detailed attributes"
  value       = data.aws_route_table.this.routes
}