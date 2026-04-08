output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_ec2_transit_gateway_connect.this.region
}

output "filter" {
  description = "Configuration blocks containing name-values filters"
  value       = var.filter
}

output "transit_gateway_connect_id" {
  description = "Identifier of the EC2 Transit Gateway Connect"
  value       = data.aws_ec2_transit_gateway_connect.this.transit_gateway_connect_id
}

output "protocol" {
  description = "Tunnel protocol"
  value       = data.aws_ec2_transit_gateway_connect.this.protocol
}

output "tags" {
  description = "Key-value tags for the EC2 Transit Gateway Connect"
  value       = data.aws_ec2_transit_gateway_connect.this.tags
}

output "transit_gateway_id" {
  description = "EC2 Transit Gateway identifier"
  value       = data.aws_ec2_transit_gateway_connect.this.transit_gateway_id
}

output "transport_attachment_id" {
  description = "The underlying VPC attachment"
  value       = data.aws_ec2_transit_gateway_connect.this.transport_attachment_id
}