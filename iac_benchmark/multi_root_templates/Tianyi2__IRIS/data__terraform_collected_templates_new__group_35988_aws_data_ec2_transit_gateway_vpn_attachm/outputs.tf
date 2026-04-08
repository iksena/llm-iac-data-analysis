output "id" {
  description = "EC2 Transit Gateway VPN Attachment identifier"
  value       = data.aws_ec2_transit_gateway_vpn_attachment.this.id
}

output "region" {
  description = "Region where this resource will be managed"
  value       = data.aws_ec2_transit_gateway_vpn_attachment.this.region
}

output "transit_gateway_id" {
  description = "Identifier of the EC2 Transit Gateway"
  value       = data.aws_ec2_transit_gateway_vpn_attachment.this.transit_gateway_id
}

output "vpn_connection_id" {
  description = "Identifier of the EC2 VPN Connection"
  value       = data.aws_ec2_transit_gateway_vpn_attachment.this.vpn_connection_id
}

output "tags" {
  description = "Key-value tags for the EC2 Transit Gateway VPN Attachment"
  value       = data.aws_ec2_transit_gateway_vpn_attachment.this.tags
}