output "id" {
  description = "The name of the subnet group."
  value       = aws_memorydb_subnet_group.this.id
}

output "arn" {
  description = "The ARN of the subnet group."
  value       = aws_memorydb_subnet_group.this.arn
}

output "vpc_id" {
  description = "The VPC in which the subnet group exists."
  value       = aws_memorydb_subnet_group.this.vpc_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_memorydb_subnet_group.this.tags_all
}