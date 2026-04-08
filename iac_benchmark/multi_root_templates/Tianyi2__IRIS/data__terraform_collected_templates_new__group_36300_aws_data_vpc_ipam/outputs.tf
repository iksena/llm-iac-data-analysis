output "arn" {
  description = "ARN of the IPAM"
  value       = data.aws_vpc_ipam.this.arn
}

output "default_resource_discovery_association_id" {
  description = "The default resource discovery association ID"
  value       = data.aws_vpc_ipam.this.default_resource_discovery_association_id
}

output "default_resource_discovery_id" {
  description = "The default resource discovery ID"
  value       = data.aws_vpc_ipam.this.default_resource_discovery_id
}

output "description" {
  description = "Description for the IPAM"
  value       = data.aws_vpc_ipam.this.description
}

output "enable_private_gua" {
  description = "If private GUA is enabled"
  value       = data.aws_vpc_ipam.this.enable_private_gua
}

output "id" {
  description = "ID of the IPAM resource"
  value       = data.aws_vpc_ipam.this.id
}

output "ipam_region" {
  description = "Region that the IPAM exists in"
  value       = data.aws_vpc_ipam.this.ipam_region
}

output "metered_account" {
  description = "AWS account that is charged for active IP addresses managed in IPAM"
  value       = data.aws_vpc_ipam.this.metered_account
}

output "operating_regions" {
  description = "Regions that the IPAM is configured to operate in"
  value       = data.aws_vpc_ipam.this.operating_regions
}

output "owner_id" {
  description = "ID of the account that owns this IPAM"
  value       = data.aws_vpc_ipam.this.owner_id
}

output "private_default_scope_id" {
  description = "ID of the default private scope"
  value       = data.aws_vpc_ipam.this.private_default_scope_id
}

output "public_default_scope_id" {
  description = "ID of the default public scope"
  value       = data.aws_vpc_ipam.this.public_default_scope_id
}

output "resource_discovery_association_count" {
  description = "Number of resource discovery associations"
  value       = data.aws_vpc_ipam.this.resource_discovery_association_count
}

output "scope_count" {
  description = "Number of scopes on this IPAM"
  value       = data.aws_vpc_ipam.this.scope_count
}

output "state" {
  description = "Current state of the IPAM"
  value       = data.aws_vpc_ipam.this.state
}

output "state_message" {
  description = "State message of the IPAM"
  value       = data.aws_vpc_ipam.this.state_message
}

output "tier" {
  description = "IPAM Tier"
  value       = data.aws_vpc_ipam.this.tier
}

output "tags" {
  description = "Tags of the IPAM resource"
  value       = data.aws_vpc_ipam.this.tags
}