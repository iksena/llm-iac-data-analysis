output "route_server_id" {
  description = "The unique identifier for the route server"
  value       = aws_vpc_route_server_propagation.this.route_server_id
}

output "route_table_id" {
  description = "The ID of the route table"
  value       = aws_vpc_route_server_propagation.this.route_table_id
}

output "region" {
  description = "The region where the resource is managed"
  value       = aws_vpc_route_server_propagation.this.region
}

