output "id" {
  description = "The ID of the network ACL association"
  value       = aws_network_acl_association.this.id
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_network_acl_association.this.region
}

output "network_acl_id" {
  description = "The ID of the network ACL"
  value       = aws_network_acl_association.this.network_acl_id
}

output "subnet_id" {
  description = "The ID of the associated Subnet"
  value       = aws_network_acl_association.this.subnet_id
}