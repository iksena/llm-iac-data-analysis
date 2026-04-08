output "id" {
  description = "EC2 Transit Gateway Default Route Table Association identifier."
  value       = aws_ec2_transit_gateway_default_route_table_association.this.id
}

output "transit_gateway_id" {
  description = "ID of the Transit Gateway."
  value       = aws_ec2_transit_gateway_default_route_table_association.this.transit_gateway_id
}

output "transit_gateway_route_table_id" {
  description = "ID of the Transit Gateway Route Table."
  value       = aws_ec2_transit_gateway_default_route_table_association.this.transit_gateway_route_table_id
}