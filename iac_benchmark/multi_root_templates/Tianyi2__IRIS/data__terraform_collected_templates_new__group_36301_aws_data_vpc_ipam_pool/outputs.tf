output "address_family" {
  description = "IP protocol assigned to this pool."
  value       = data.aws_vpc_ipam_pool.this.address_family
}

output "allocation_default_netmask_length" {
  description = "A default netmask length for allocations added to this pool."
  value       = data.aws_vpc_ipam_pool.this.allocation_default_netmask_length
}

output "allocation_max_netmask_length" {
  description = "The maximum netmask length that will be required for CIDR allocations in this pool."
  value       = data.aws_vpc_ipam_pool.this.allocation_max_netmask_length
}

output "allocation_min_netmask_length" {
  description = "The minimum netmask length that will be required for CIDR allocations in this pool."
  value       = data.aws_vpc_ipam_pool.this.allocation_min_netmask_length
}

output "allocation_resource_tags" {
  description = "Tags that are required to create resources in using this pool."
  value       = data.aws_vpc_ipam_pool.this.allocation_resource_tags
}

output "arn" {
  description = "ARN of the pool."
  value       = data.aws_vpc_ipam_pool.this.arn
}

output "auto_import" {
  description = "If enabled, IPAM will continuously look for resources within the CIDR range of this pool and automatically import them as allocations into your IPAM."
  value       = data.aws_vpc_ipam_pool.this.auto_import
}

output "aws_service" {
  description = "Limits which service in AWS that the pool can be used in."
  value       = data.aws_vpc_ipam_pool.this.aws_service
}

output "description" {
  description = "Description for the IPAM pool."
  value       = data.aws_vpc_ipam_pool.this.description
}

output "id" {
  description = "ID of the IPAM pool."
  value       = data.aws_vpc_ipam_pool.this.id
}

output "ipam_scope_id" {
  description = "ID of the scope the pool belongs to."
  value       = data.aws_vpc_ipam_pool.this.ipam_scope_id
}

output "locale" {
  description = "Locale is the Region where your pool is available for allocations."
  value       = data.aws_vpc_ipam_pool.this.locale
}

output "publicly_advertisable" {
  description = "Defines whether or not IPv6 pool space is publicly advertisable over the internet."
  value       = data.aws_vpc_ipam_pool.this.publicly_advertisable
}

output "source_ipam_pool_id" {
  description = "ID of the source IPAM pool."
  value       = data.aws_vpc_ipam_pool.this.source_ipam_pool_id
}

output "tags" {
  description = "Map of tags assigned to the resource."
  value       = data.aws_vpc_ipam_pool.this.tags
}