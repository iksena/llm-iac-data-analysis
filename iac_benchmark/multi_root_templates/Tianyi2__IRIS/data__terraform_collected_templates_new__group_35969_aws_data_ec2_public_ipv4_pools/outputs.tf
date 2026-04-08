output "pool_ids" {
  description = "List of all the pool IDs found."
  value       = data.aws_ec2_public_ipv4_pools.this.pool_ids
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_ec2_public_ipv4_pools.this.region
}

output "filter" {
  description = "Custom filter block used to filter pools."
  value       = var.filter
}

output "tags" {
  description = "Map of tags used to filter pools."
  value       = data.aws_ec2_public_ipv4_pools.this.tags
}