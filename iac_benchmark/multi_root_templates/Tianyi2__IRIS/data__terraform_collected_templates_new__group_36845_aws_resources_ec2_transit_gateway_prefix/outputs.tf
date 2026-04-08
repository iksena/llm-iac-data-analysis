output "id" {
  description = "EC2 Transit Gateway Route Table identifier and EC2 Prefix List identifier, separated by an underscore (_)"
  value       = aws_ec2_transit_gateway_prefix_list_reference.this.id
}

output "prefix_list_id" {
  description = "Identifier of EC2 Prefix List"
  value       = aws_ec2_transit_gateway_prefix_list_reference.this.prefix_list_id
}

output "transit_gateway_route_table_id" {
  description = "Identifier of EC2 Transit Gateway Route Table"
  value       = aws_ec2_transit_gateway_prefix_list_reference.this.transit_gateway_route_table_id
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_ec2_transit_gateway_prefix_list_reference.this.region
}

output "blackhole" {
  description = "Indicates whether to drop traffic that matches the Prefix List"
  value       = aws_ec2_transit_gateway_prefix_list_reference.this.blackhole
}

output "transit_gateway_attachment_id" {
  description = "Identifier of EC2 Transit Gateway Attachment"
  value       = aws_ec2_transit_gateway_prefix_list_reference.this.transit_gateway_attachment_id
}