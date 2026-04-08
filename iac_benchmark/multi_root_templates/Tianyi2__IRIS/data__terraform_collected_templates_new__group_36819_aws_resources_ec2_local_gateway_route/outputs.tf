output "id" {
  description = "EC2 Local Gateway Route Table identifier and destination CIDR block separated by underscores (_)"
  value       = aws_ec2_local_gateway_route.this.id
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_ec2_local_gateway_route.this.region
}

output "destination_cidr_block" {
  description = "IPv4 CIDR range used for destination matches"
  value       = aws_ec2_local_gateway_route.this.destination_cidr_block
}

output "local_gateway_route_table_id" {
  description = "Identifier of EC2 Local Gateway Route Table"
  value       = aws_ec2_local_gateway_route.this.local_gateway_route_table_id
}

output "local_gateway_virtual_interface_group_id" {
  description = "Identifier of EC2 Local Gateway Virtual Interface Group"
  value       = aws_ec2_local_gateway_route.this.local_gateway_virtual_interface_group_id
}