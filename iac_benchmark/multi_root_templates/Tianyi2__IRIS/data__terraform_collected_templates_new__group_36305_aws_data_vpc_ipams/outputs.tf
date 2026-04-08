output "ipams" {
  description = "List of IPAM resources matching the provided arguments"
  value       = data.aws_vpc_ipams.this.ipams
}

output "arn" {
  description = "ARNs of the IPAMs"
  value       = [for ipam in data.aws_vpc_ipams.this.ipams : ipam.arn]
}

output "default_resource_discovery_association_id" {
  description = "The default resource discovery association IDs"
  value       = [for ipam in data.aws_vpc_ipams.this.ipams : ipam.default_resource_discovery_association_id]
}

output "default_resource_discovery_id" {
  description = "The default resource discovery IDs"
  value       = [for ipam in data.aws_vpc_ipams.this.ipams : ipam.default_resource_discovery_id]
}

output "description" {
  description = "Descriptions for the IPAMs"
  value       = [for ipam in data.aws_vpc_ipams.this.ipams : ipam.description]
}

output "enable_private_gua" {
  description = "If private GUA is enabled"
  value       = [for ipam in data.aws_vpc_ipams.this.ipams : ipam.enable_private_gua]
}

output "id" {
  description = "IDs of the IPAM resources"
  value       = [for ipam in data.aws_vpc_ipams.this.ipams : ipam.id]
}

output "ipam_region" {
  description = "Regions that the IPAMs exist in"
  value       = [for ipam in data.aws_vpc_ipams.this.ipams : ipam.ipam_region]
}

output "operating_regions" {
  description = "Regions that the IPAMs are configured to operate in"
  value       = [for ipam in data.aws_vpc_ipams.this.ipams : ipam.operating_regions]
}

output "owner_id" {
  description = "IDs of the accounts that own these IPAMs"
  value       = [for ipam in data.aws_vpc_ipams.this.ipams : ipam.owner_id]
}

output "private_default_scope_id" {
  description = "IDs of the default private scopes"
  value       = [for ipam in data.aws_vpc_ipams.this.ipams : ipam.private_default_scope_id]
}

output "public_default_scope_id" {
  description = "IDs of the default public scopes"
  value       = [for ipam in data.aws_vpc_ipams.this.ipams : ipam.public_default_scope_id]
}

output "resource_discovery_association_count" {
  description = "Numbers of resource discovery associations"
  value       = [for ipam in data.aws_vpc_ipams.this.ipams : ipam.resource_discovery_association_count]
}

output "scope_count" {
  description = "Numbers of scopes on these IPAMs"
  value       = [for ipam in data.aws_vpc_ipams.this.ipams : ipam.scope_count]
}

output "state" {
  description = "Current states of the IPAMs"
  value       = [for ipam in data.aws_vpc_ipams.this.ipams : ipam.state]
}

output "state_message" {
  description = "State messages of the IPAMs"
  value       = [for ipam in data.aws_vpc_ipams.this.ipams : ipam.state_message]
}

output "tier" {
  description = "IPAM Tiers"
  value       = [for ipam in data.aws_vpc_ipams.this.ipams : ipam.tier]
}