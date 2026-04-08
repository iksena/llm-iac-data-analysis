output "ipam_pools" {
  description = "List of IPAM pools and their attributes"
  value       = data.aws_vpc_ipam_pools.this.ipam_pools
}

output "address_family" {
  description = "IP protocol assigned to pools"
  value       = [for pool in data.aws_vpc_ipam_pools.this.ipam_pools : pool.address_family]
}

output "allocation_default_netmask_length" {
  description = "Default netmask length for allocations added to pools"
  value       = [for pool in data.aws_vpc_ipam_pools.this.ipam_pools : pool.allocation_default_netmask_length]
}

output "allocation_max_netmask_length" {
  description = "Maximum netmask length required for CIDR allocations in pools"
  value       = [for pool in data.aws_vpc_ipam_pools.this.ipam_pools : pool.allocation_max_netmask_length]
}

output "allocation_min_netmask_length" {
  description = "Minimum netmask length required for CIDR allocations in pools"
  value       = [for pool in data.aws_vpc_ipam_pools.this.ipam_pools : pool.allocation_min_netmask_length]
}

output "allocation_resource_tags" {
  description = "Tags required to create resources in using pools"
  value       = [for pool in data.aws_vpc_ipam_pools.this.ipam_pools : pool.allocation_resource_tags]
}

output "arn" {
  description = "ARN of the pools"
  value       = [for pool in data.aws_vpc_ipam_pools.this.ipam_pools : pool.arn]
}

output "auto_import" {
  description = "Whether IPAM continuously looks for resources within CIDR range and automatically imports them"
  value       = [for pool in data.aws_vpc_ipam_pools.this.ipam_pools : pool.auto_import]
}

output "aws_service" {
  description = "AWS service that the pools can be used in"
  value       = [for pool in data.aws_vpc_ipam_pools.this.ipam_pools : pool.aws_service]
}

output "description" {
  description = "Description for the IPAM pools"
  value       = [for pool in data.aws_vpc_ipam_pools.this.ipam_pools : pool.description]
}

output "id" {
  description = "ID of the IPAM pools"
  value       = [for pool in data.aws_vpc_ipam_pools.this.ipam_pools : pool.id]
}

output "ipam_scope_id" {
  description = "ID of the scope the pools belong to"
  value       = [for pool in data.aws_vpc_ipam_pools.this.ipam_pools : pool.ipam_scope_id]
}

output "locale" {
  description = "Region where pools are available for allocations"
  value       = [for pool in data.aws_vpc_ipam_pools.this.ipam_pools : pool.locale]
}

output "publicly_advertisable" {
  description = "Whether IPv6 pool space is publicly advertisable over the internet"
  value       = [for pool in data.aws_vpc_ipam_pools.this.ipam_pools : pool.publicly_advertisable]
}

output "source_ipam_pool_id" {
  description = "ID of the source IPAM pools"
  value       = [for pool in data.aws_vpc_ipam_pools.this.ipam_pools : pool.source_ipam_pool_id]
}

output "tags" {
  description = "Map of tags assigned to the pools"
  value       = [for pool in data.aws_vpc_ipam_pools.this.ipam_pools : pool.tags]
}