output "arn" {
  description = "Core Network ARN"
  value       = aws_networkmanager_core_network.this.arn
}

output "created_at" {
  description = "Timestamp when a core network was created"
  value       = aws_networkmanager_core_network.this.created_at
}

output "edges" {
  description = "One or more blocks detailing the edges within a core network"
  value       = aws_networkmanager_core_network.this.edges
}

output "id" {
  description = "Core Network ID"
  value       = aws_networkmanager_core_network.this.id
}

output "segments" {
  description = "One or more blocks detailing the segments within a core network"
  value       = aws_networkmanager_core_network.this.segments
}

output "state" {
  description = "Current state of a core network"
  value       = aws_networkmanager_core_network.this.state
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_networkmanager_core_network.this.tags_all
}