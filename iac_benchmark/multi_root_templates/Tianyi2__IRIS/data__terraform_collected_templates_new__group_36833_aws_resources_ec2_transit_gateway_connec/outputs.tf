output "id" {
  description = "EC2 Transit Gateway Attachment identifier"
  value       = aws_ec2_transit_gateway_connect.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ec2_transit_gateway_connect.this.tags_all
}

output "region" {
  description = "Region where this resource will be managed."
  value       = aws_ec2_transit_gateway_connect.this.region
}

output "protocol" {
  description = "The tunnel protocol."
  value       = aws_ec2_transit_gateway_connect.this.protocol
}

output "tags" {
  description = "Key-value tags for the EC2 Transit Gateway Connect."
  value       = aws_ec2_transit_gateway_connect.this.tags
}

output "transit_gateway_default_route_table_association" {
  description = "Boolean whether the Connect should be associated with the EC2 Transit Gateway association default route table."
  value       = aws_ec2_transit_gateway_connect.this.transit_gateway_default_route_table_association
}

output "transit_gateway_default_route_table_propagation" {
  description = "Boolean whether the Connect should propagate routes with the EC2 Transit Gateway propagation default route table."
  value       = aws_ec2_transit_gateway_connect.this.transit_gateway_default_route_table_propagation
}

output "transit_gateway_id" {
  description = "Identifier of EC2 Transit Gateway."
  value       = aws_ec2_transit_gateway_connect.this.transit_gateway_id
}

output "transport_attachment_id" {
  description = "The underlaying VPC attachment"
  value       = aws_ec2_transit_gateway_connect.this.transport_attachment_id
}