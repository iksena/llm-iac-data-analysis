output "id" {
  description = "EC2 Transit Gateway Route Table identifier combined with EC2 Transit Gateway Attachment identifier"
  value       = aws_ec2_transit_gateway_route_table_propagation.this.id
}

output "resource_id" {
  description = "Identifier of the resource"
  value       = aws_ec2_transit_gateway_route_table_propagation.this.resource_id
}

output "resource_type" {
  description = "Type of the resource"
  value       = aws_ec2_transit_gateway_route_table_propagation.this.resource_type
}