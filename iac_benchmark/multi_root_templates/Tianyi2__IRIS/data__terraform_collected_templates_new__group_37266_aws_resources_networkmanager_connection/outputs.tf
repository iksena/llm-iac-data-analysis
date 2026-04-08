output "arn" {
  description = "ARN of the connection"
  value       = aws_networkmanager_connection.this.arn
}

output "connected_device_id" {
  description = "ID of the second device in the connection"
  value       = aws_networkmanager_connection.this.connected_device_id
}

output "connected_link_id" {
  description = "ID of the link for the second device"
  value       = aws_networkmanager_connection.this.connected_link_id
}

output "description" {
  description = "Description of the connection"
  value       = aws_networkmanager_connection.this.description
}

output "device_id" {
  description = "ID of the first device in the connection"
  value       = aws_networkmanager_connection.this.device_id
}

output "global_network_id" {
  description = "ID of the global network"
  value       = aws_networkmanager_connection.this.global_network_id
}

output "link_id" {
  description = "ID of the link for the first device"
  value       = aws_networkmanager_connection.this.link_id
}

output "tags" {
  description = "Key-value tags for the connection"
  value       = aws_networkmanager_connection.this.tags
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_networkmanager_connection.this.tags_all
}