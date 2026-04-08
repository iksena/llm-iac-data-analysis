output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_ec2_coip_pool.this.region
}

output "local_gateway_route_table_id" {
  description = "Local Gateway Route Table Id assigned to COIP Pool"
  value       = data.aws_ec2_coip_pool.this.local_gateway_route_table_id
}

output "pool_id" {
  description = "ID of the COIP Pool"
  value       = data.aws_ec2_coip_pool.this.pool_id
}

output "tags" {
  description = "Mapping of tags on the COIP Pool"
  value       = data.aws_ec2_coip_pool.this.tags
}

output "arn" {
  description = "ARN of the COIP pool"
  value       = data.aws_ec2_coip_pool.this.arn
}

output "pool_cidrs" {
  description = "Set of CIDR blocks in pool"
  value       = data.aws_ec2_coip_pool.this.pool_cidrs
}