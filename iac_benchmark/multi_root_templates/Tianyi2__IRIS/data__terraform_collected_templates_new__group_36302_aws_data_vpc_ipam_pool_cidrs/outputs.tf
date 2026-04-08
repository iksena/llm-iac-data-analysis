output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_vpc_ipam_pool_cidrs.this.region
}

output "ipam_pool_id" {
  description = "ID of the IPAM pool."
  value       = data.aws_vpc_ipam_pool_cidrs.this.ipam_pool_id
}

output "filter" {
  description = "Custom filter blocks used."
  value       = data.aws_vpc_ipam_pool_cidrs.this.filter
}

output "ipam_pool_cidrs" {
  description = "The CIDRs provisioned into the IPAM pool."
  value       = data.aws_vpc_ipam_pool_cidrs.this.ipam_pool_cidrs
}

output "ipam_pool_cidrs_cidr" {
  description = "List of network CIDRs from the IPAM pool."
  value       = [for cidr in data.aws_vpc_ipam_pool_cidrs.this.ipam_pool_cidrs : cidr.cidr]
}

output "ipam_pool_cidrs_state" {
  description = "List of provisioning states for each CIDR."
  value       = [for cidr in data.aws_vpc_ipam_pool_cidrs.this.ipam_pool_cidrs : cidr.state]
}