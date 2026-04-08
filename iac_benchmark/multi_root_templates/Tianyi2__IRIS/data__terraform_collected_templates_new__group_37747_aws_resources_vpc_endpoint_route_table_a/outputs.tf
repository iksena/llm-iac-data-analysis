output "id" {
  description = "A hash of the EC2 Route Table and VPC Endpoint identifiers."
  value       = aws_vpc_endpoint_route_table_association.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_vpc_endpoint_route_table_association.this.region
}

output "route_table_id" {
  description = "Identifier of the EC2 Route Table associated with the VPC Endpoint."
  value       = aws_vpc_endpoint_route_table_association.this.route_table_id
}

output "vpc_endpoint_id" {
  description = "Identifier of the VPC Endpoint associated with the EC2 Route Table."
  value       = aws_vpc_endpoint_route_table_association.this.vpc_endpoint_id
}