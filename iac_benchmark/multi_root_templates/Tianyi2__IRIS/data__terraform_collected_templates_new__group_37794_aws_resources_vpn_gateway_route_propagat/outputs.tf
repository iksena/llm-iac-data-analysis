output "id" {
  description = "The ID of the VPN gateway route propagation"
  value       = aws_vpn_gateway_route_propagation.this.id
}

output "region" {
  description = "The region where the VPN gateway route propagation is managed"
  value       = aws_vpn_gateway_route_propagation.this.region
}

output "vpn_gateway_id" {
  description = "The ID of the VPN gateway"
  value       = aws_vpn_gateway_route_propagation.this.vpn_gateway_id
}

output "route_table_id" {
  description = "The ID of the route table"
  value       = aws_vpn_gateway_route_propagation.this.route_table_id
}