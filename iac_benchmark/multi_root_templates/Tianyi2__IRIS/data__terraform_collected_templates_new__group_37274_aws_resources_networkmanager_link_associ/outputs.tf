output "device_id" {
  description = "ID of the device"
  value       = aws_networkmanager_link_association.this.device_id
}

output "global_network_id" {
  description = "ID of the global network"
  value       = aws_networkmanager_link_association.this.global_network_id
}

output "link_id" {
  description = "ID of the link"
  value       = aws_networkmanager_link_association.this.link_id
}

output "id" {
  description = "The ID of the link association (composite of global_network_id,link_id,device_id)"
  value       = aws_networkmanager_link_association.this.id
}