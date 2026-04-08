output "arn" {
  description = "Amazon Resource Name (ARN) of the VPN Connection"
  value       = aws_vpn_connection.this.arn
}

output "id" {
  description = "The amazon-assigned ID of the VPN connection"
  value       = aws_vpn_connection.this.id
}

output "core_network_arn" {
  description = "The ARN of the core network"
  value       = aws_vpn_connection.this.core_network_arn
}

output "core_network_attachment_arn" {
  description = "The ARN of the core network attachment"
  value       = aws_vpn_connection.this.core_network_attachment_arn
}

output "customer_gateway_configuration" {
  description = "The configuration information for the VPN connection's customer gateway (in the native XML format)"
  value       = aws_vpn_connection.this.customer_gateway_configuration
}

output "customer_gateway_id" {
  description = "The ID of the customer gateway to which the connection is attached"
  value       = aws_vpn_connection.this.customer_gateway_id
}

output "routes" {
  description = "The static routes associated with the VPN connection"
  value       = aws_vpn_connection.this.routes
}

output "preshared_key_arn" {
  description = "ARN of the Secrets Manager secret storing the pre-shared key(s) for the VPN connection"
  value       = aws_vpn_connection.this.preshared_key_arn
}

output "static_routes_only" {
  description = "Whether the VPN connection uses static routes exclusively"
  value       = aws_vpn_connection.this.static_routes_only
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_vpn_connection.this.tags_all
}

output "transit_gateway_attachment_id" {
  description = "When associated with an EC2 Transit Gateway (transit_gateway_id argument), the attachment ID"
  value       = aws_vpn_connection.this.transit_gateway_attachment_id
}

output "tunnel1_address" {
  description = "The public IP address of the first VPN tunnel"
  value       = aws_vpn_connection.this.tunnel1_address
}

output "tunnel1_cgw_inside_address" {
  description = "The RFC 6890 link-local address of the first VPN tunnel (Customer Gateway Side)"
  value       = aws_vpn_connection.this.tunnel1_cgw_inside_address
}

output "tunnel1_vgw_inside_address" {
  description = "The RFC 6890 link-local address of the first VPN tunnel (VPN Gateway Side)"
  value       = aws_vpn_connection.this.tunnel1_vgw_inside_address
}

output "tunnel1_preshared_key" {
  description = "The preshared key of the first VPN tunnel"
  value       = aws_vpn_connection.this.tunnel1_preshared_key
  sensitive   = true
}

output "tunnel1_bgp_asn" {
  description = "The bgp asn number of the first VPN tunnel"
  value       = aws_vpn_connection.this.tunnel1_bgp_asn
}

output "tunnel1_bgp_holdtime" {
  description = "The bgp holdtime of the first VPN tunnel"
  value       = aws_vpn_connection.this.tunnel1_bgp_holdtime
}

output "tunnel2_address" {
  description = "The public IP address of the second VPN tunnel"
  value       = aws_vpn_connection.this.tunnel2_address
}

output "tunnel2_cgw_inside_address" {
  description = "The RFC 6890 link-local address of the second VPN tunnel (Customer Gateway Side)"
  value       = aws_vpn_connection.this.tunnel2_cgw_inside_address
}

output "tunnel2_vgw_inside_address" {
  description = "The RFC 6890 link-local address of the second VPN tunnel (VPN Gateway Side)"
  value       = aws_vpn_connection.this.tunnel2_vgw_inside_address
}

output "tunnel2_preshared_key" {
  description = "The preshared key of the second VPN tunnel"
  value       = aws_vpn_connection.this.tunnel2_preshared_key
  sensitive   = true
}

output "tunnel2_bgp_asn" {
  description = "The bgp asn number of the second VPN tunnel"
  value       = aws_vpn_connection.this.tunnel2_bgp_asn
}

output "tunnel2_bgp_holdtime" {
  description = "The bgp holdtime of the second VPN tunnel"
  value       = aws_vpn_connection.this.tunnel2_bgp_holdtime
}

output "vgw_telemetry" {
  description = "Telemetry for the VPN tunnels"
  value       = aws_vpn_connection.this.vgw_telemetry
}

output "vpn_gateway_id" {
  description = "The ID of the virtual private gateway to which the connection is attached"
  value       = aws_vpn_connection.this.vpn_gateway_id
}