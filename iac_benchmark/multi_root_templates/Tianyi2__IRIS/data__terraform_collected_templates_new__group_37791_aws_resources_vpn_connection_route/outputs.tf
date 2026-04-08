output "destination_cidr_block" {
  description = "The CIDR block associated with the local subnet of the customer network."
  value       = aws_vpn_connection_route.this.destination_cidr_block
}

output "vpn_connection_id" {
  description = "The ID of the VPN connection."
  value       = aws_vpn_connection_route.this.vpn_connection_id
}