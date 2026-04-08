output "arn" {
  description = "Amazon Resource Name (ARN) of IPAM"
  value       = aws_vpc_ipam.this.arn
}

output "id" {
  description = "The ID of the IPAM"
  value       = aws_vpc_ipam.this.id
}

output "default_resource_discovery_id" {
  description = "The IPAM's default resource discovery ID"
  value       = aws_vpc_ipam.this.default_resource_discovery_id
}

output "default_resource_discovery_association_id" {
  description = "The IPAM's default resource discovery association ID"
  value       = aws_vpc_ipam.this.default_resource_discovery_association_id
}

output "private_default_scope_id" {
  description = "The ID of the IPAM's private scope"
  value       = aws_vpc_ipam.this.private_default_scope_id
}

output "public_default_scope_id" {
  description = "The ID of the IPAM's public scope"
  value       = aws_vpc_ipam.this.public_default_scope_id
}

output "scope_count" {
  description = "The number of scopes in the IPAM"
  value       = aws_vpc_ipam.this.scope_count
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_vpc_ipam.this.tags_all
}