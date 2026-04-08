output "device_id" {
  description = "ID of the device."
  value       = aws_networkmanager_transit_gateway_connect_peer_association.this.device_id
}

output "global_network_id" {
  description = "ID of the global network."
  value       = aws_networkmanager_transit_gateway_connect_peer_association.this.global_network_id
}

output "transit_gateway_connect_peer_arn" {
  description = "ARN of the Connect peer."
  value       = aws_networkmanager_transit_gateway_connect_peer_association.this.transit_gateway_connect_peer_arn
}

output "link_id" {
  description = "ID of the link."
  value       = aws_networkmanager_transit_gateway_connect_peer_association.this.link_id
}