output "arn" {
  description = "ARN of the network interface"
  value       = aws_network_interface.this.arn
}

output "id" {
  description = "ID of the network interface"
  value       = aws_network_interface.this.id
}

output "mac_address" {
  description = "MAC address of the network interface"
  value       = aws_network_interface.this.mac_address
}

output "owner_id" {
  description = "AWS account ID of the owner of the network interface"
  value       = aws_network_interface.this.owner_id
}

output "private_dns_name" {
  description = "Private DNS name of the network interface (IPv4)"
  value       = aws_network_interface.this.private_dns_name
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_network_interface.this.tags_all
}