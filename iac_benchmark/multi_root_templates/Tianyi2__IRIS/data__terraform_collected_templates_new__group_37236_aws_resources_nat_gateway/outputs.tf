output "association_id" {
  description = "The association ID of the Elastic IP address that's associated with the NAT Gateway. Only available when connectivity_type is public."
  value       = aws_nat_gateway.this.association_id
}

output "id" {
  description = "The ID of the NAT Gateway."
  value       = aws_nat_gateway.this.id
}

output "network_interface_id" {
  description = "The ID of the network interface associated with the NAT Gateway."
  value       = aws_nat_gateway.this.network_interface_id
}

output "public_ip" {
  description = "The Elastic IP address associated with the NAT Gateway."
  value       = aws_nat_gateway.this.public_ip
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_nat_gateway.this.tags_all
}