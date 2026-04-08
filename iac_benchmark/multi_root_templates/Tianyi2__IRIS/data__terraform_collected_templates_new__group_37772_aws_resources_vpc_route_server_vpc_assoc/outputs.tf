
output "route_server_id" {
  description = "The unique identifier for the route server"
  value       = aws_vpc_route_server_vpc_association.this.route_server_id
}

output "vpc_id" {
  description = "The ID of the VPC associated with the route server"
  value       = aws_vpc_route_server_vpc_association.this.vpc_id
}

output "region" {
  description = "The region where the resource is managed"
  value       = aws_vpc_route_server_vpc_association.this.region
}