output "id" {
  description = "The db subnet group name"
  value       = aws_db_subnet_group.this.id
}

output "arn" {
  description = "The ARN of the db subnet group"
  value       = aws_db_subnet_group.this.arn
}

output "supported_network_types" {
  description = "The network type of the db subnet group"
  value       = aws_db_subnet_group.this.supported_network_types
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_db_subnet_group.this.tags_all
}

output "vpc_id" {
  description = "Provides the VPC ID of the DB subnet group"
  value       = aws_db_subnet_group.this.vpc_id
}