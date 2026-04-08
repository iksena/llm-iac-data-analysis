output "arn" {
  description = "ARN of the Dedicated IP Pool."
  value       = data.aws_sesv2_dedicated_ip_pool.this.arn
}

output "dedicated_ips" {
  description = "A list of objects describing the pool's dedicated IP's."
  value       = data.aws_sesv2_dedicated_ip_pool.this.dedicated_ips
}

output "scaling_mode" {
  description = "IP pool scaling mode. Valid values: STANDARD, MANAGED."
  value       = data.aws_sesv2_dedicated_ip_pool.this.scaling_mode
}

output "tags" {
  description = "A map of tags attached to the pool."
  value       = data.aws_sesv2_dedicated_ip_pool.this.tags
}

output "pool_name" {
  description = "Name of the dedicated IP pool."
  value       = data.aws_sesv2_dedicated_ip_pool.this.pool_name
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_sesv2_dedicated_ip_pool.this.region
}