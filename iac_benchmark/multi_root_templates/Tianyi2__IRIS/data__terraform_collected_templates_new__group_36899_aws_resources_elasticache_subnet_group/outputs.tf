output "region" {
  description = "Region where this resource will be managed."
  value       = aws_elasticache_subnet_group.this.region
}

output "name" {
  description = "Name for the cache subnet group."
  value       = aws_elasticache_subnet_group.this.name
}

output "description" {
  description = "Description for the cache subnet group."
  value       = aws_elasticache_subnet_group.this.description
}

output "subnet_ids" {
  description = "List of VPC Subnet IDs for the cache subnet group."
  value       = aws_elasticache_subnet_group.this.subnet_ids
}

output "tags" {
  description = "Key-value map of resource tags."
  value       = aws_elasticache_subnet_group.this.tags
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_elasticache_subnet_group.this.tags_all
}

output "vpc_id" {
  description = "The Amazon Virtual Private Cloud identifier (VPC ID) of the cache subnet group."
  value       = aws_elasticache_subnet_group.this.vpc_id
}