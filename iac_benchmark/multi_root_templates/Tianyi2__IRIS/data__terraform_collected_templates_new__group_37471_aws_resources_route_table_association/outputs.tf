output "id" {
  description = "The ID of the association"
  value       = aws_route_table_association.this.id
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_route_table_association.this.region
}

output "subnet_id" {
  description = "The subnet ID of the association"
  value       = aws_route_table_association.this.subnet_id
}

output "gateway_id" {
  description = "The gateway ID of the association"
  value       = aws_route_table_association.this.gateway_id
}

output "route_table_id" {
  description = "The ID of the routing table"
  value       = aws_route_table_association.this.route_table_id
}