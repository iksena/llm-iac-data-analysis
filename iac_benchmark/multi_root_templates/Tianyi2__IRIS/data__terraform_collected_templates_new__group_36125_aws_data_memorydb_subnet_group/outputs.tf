output "id" {
  value       = data.aws_memorydb_subnet_group.this.id
  description = "Name of the subnet group."
}

output "arn" {
  value       = data.aws_memorydb_subnet_group.this.arn
  description = "ARN of the subnet group."
}

output "description" {
  value       = data.aws_memorydb_subnet_group.this.description
  description = "Description of the subnet group."
}

output "subnet_ids" {
  value       = data.aws_memorydb_subnet_group.this.subnet_ids
  description = "Set of VPC Subnet ID-s of the subnet group."
}

output "vpc_id" {
  value       = data.aws_memorydb_subnet_group.this.vpc_id
  description = "VPC in which the subnet group exists."
}

output "tags" {
  value       = data.aws_memorydb_subnet_group.this.tags
  description = "Map of tags assigned to the subnet group."
}