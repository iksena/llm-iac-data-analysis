output "arn" {
  description = "Peering ARN"
  value       = aws_networkmanager_transit_gateway_peering.this.arn
}

output "core_network_arn" {
  description = "ARN of the core network"
  value       = aws_networkmanager_transit_gateway_peering.this.core_network_arn
}

output "edge_location" {
  description = "Edge location for the peer"
  value       = aws_networkmanager_transit_gateway_peering.this.edge_location
}

output "id" {
  description = "Peering ID"
  value       = aws_networkmanager_transit_gateway_peering.this.id
}

output "owner_account_id" {
  description = "ID of the account owner"
  value       = aws_networkmanager_transit_gateway_peering.this.owner_account_id
}

output "peering_type" {
  description = "Type of peering. This will be TRANSIT_GATEWAY"
  value       = aws_networkmanager_transit_gateway_peering.this.peering_type
}

output "resource_arn" {
  description = "Resource ARN of the peer"
  value       = aws_networkmanager_transit_gateway_peering.this.resource_arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_networkmanager_transit_gateway_peering.this.tags_all
}

output "transit_gateway_peering_attachment_id" {
  description = "ID of the transit gateway peering attachment"
  value       = aws_networkmanager_transit_gateway_peering.this.transit_gateway_peering_attachment_id
}