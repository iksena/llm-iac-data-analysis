output "id" {
  description = "Name of the subnet group"
  value       = data.aws_elasticache_subnet_group.this.id
}

output "arn" {
  description = "ARN of the subnet group"
  value       = data.aws_elasticache_subnet_group.this.arn
}

output "name" {
  description = "Name of the subnet group"
  value       = data.aws_elasticache_subnet_group.this.name
}

output "description" {
  description = "Description of the subnet group"
  value       = data.aws_elasticache_subnet_group.this.description
}

output "subnet_ids" {
  description = "Set of VPC Subnet ID-s of the subnet group"
  value       = data.aws_elasticache_subnet_group.this.subnet_ids
}

output "tags" {
  description = "Map of tags assigned to the subnet group"
  value       = data.aws_elasticache_subnet_group.this.tags
}

output "vpc_id" {
  description = "The Amazon Virtual Private Cloud identifier (VPC ID) of the cache subnet group"
  value       = data.aws_elasticache_subnet_group.this.vpc_id
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_elasticache_subnet_group.this.region
}