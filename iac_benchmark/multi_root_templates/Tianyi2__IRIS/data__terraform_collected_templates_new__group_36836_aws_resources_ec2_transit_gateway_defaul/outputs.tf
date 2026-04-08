output "id" {
  description = "ID of the Transit Gateway Default Route Table Propagation resource."
  value       = aws_ec2_transit_gateway_default_route_table_propagation.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_ec2_transit_gateway_default_route_table_propagation.this.region
}

output "transit_gateway_id" {
  description = "ID of the Transit Gateway."
  value       = aws_ec2_transit_gateway_default_route_table_propagation.this.transit_gateway_id
}

output "transit_gateway_route_table_id" {
  description = "ID of the Transit Gateway Route Table."
  value       = aws_ec2_transit_gateway_default_route_table_propagation.this.transit_gateway_route_table_id
}