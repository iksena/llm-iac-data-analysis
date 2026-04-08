output "id" {
  description = "AWS Region."
  value       = data.aws_ec2_coip_pools.this.id
}

output "pool_ids" {
  description = "Set of COIP Pool Identifiers"
  value       = data.aws_ec2_coip_pools.this.pool_ids
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_ec2_coip_pools.this.region
}

output "tags" {
  description = "Mapping of tags on the COIP pools."
  value       = data.aws_ec2_coip_pools.this.tags
}

output "filter" {
  description = "Custom filter blocks used for filtering."
  value       = var.filter
}