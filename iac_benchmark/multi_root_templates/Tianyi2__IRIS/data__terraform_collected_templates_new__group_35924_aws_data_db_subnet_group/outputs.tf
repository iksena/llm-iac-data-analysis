output "name" {
  description = "Name of the RDS database subnet group."
  value       = data.aws_db_subnet_group.this.name
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_db_subnet_group.this.region
}

output "arn" {
  description = "ARN for the DB subnet group."
  value       = data.aws_db_subnet_group.this.arn
}

output "description" {
  description = "Provides the description of the DB subnet group."
  value       = data.aws_db_subnet_group.this.description
}

output "status" {
  description = "Provides the status of the DB subnet group."
  value       = data.aws_db_subnet_group.this.status
}

output "subnet_ids" {
  description = "Contains a list of subnet identifiers."
  value       = data.aws_db_subnet_group.this.subnet_ids
}

output "supported_network_types" {
  description = "The network type of the DB subnet group."
  value       = data.aws_db_subnet_group.this.supported_network_types
}

output "vpc_id" {
  description = "Provides the VPC ID of the DB subnet group."
  value       = data.aws_db_subnet_group.this.vpc_id
}