output "description" {
  description = "Description of the pool, if any"
  value       = data.aws_ec2_public_ipv4_pool.this.description
}

output "network_border_group" {
  description = "Name of the location from which the address pool is advertised"
  value       = data.aws_ec2_public_ipv4_pool.this.network_border_group
}

output "pool_address_ranges" {
  description = "List of Address Ranges in the Pool"
  value       = data.aws_ec2_public_ipv4_pool.this.pool_address_ranges
}

output "tags" {
  description = "Any tags for the address pool"
  value       = data.aws_ec2_public_ipv4_pool.this.tags
}

output "total_address_count" {
  description = "Total number of addresses in the pool"
  value       = data.aws_ec2_public_ipv4_pool.this.total_address_count
}

output "total_available_address_count" {
  description = "Total number of available addresses in the pool"
  value       = data.aws_ec2_public_ipv4_pool.this.total_available_address_count
}