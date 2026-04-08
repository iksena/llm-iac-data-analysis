output "arn" {
  description = "ARN of the Connect peer"
  value       = aws_networkmanager_connect_peer.this.arn
}

output "configuration" {
  description = "Configuration of the Connect peer"
  value       = aws_networkmanager_connect_peer.this.configuration
}

output "connect_peer_id" {
  description = "ID of the Connect peer"
  value       = aws_networkmanager_connect_peer.this.connect_peer_id
}

output "core_network_id" {
  description = "ID of a core network"
  value       = aws_networkmanager_connect_peer.this.core_network_id
}

output "created_at" {
  description = "Timestamp when the Connect peer was created"
  value       = aws_networkmanager_connect_peer.this.created_at
}

output "edge_location" {
  description = "Region where the peer is located"
  value       = aws_networkmanager_connect_peer.this.edge_location
}

output "state" {
  description = "State of the Connect peer"
  value       = aws_networkmanager_connect_peer.this.state
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_networkmanager_connect_peer.this.tags_all
}