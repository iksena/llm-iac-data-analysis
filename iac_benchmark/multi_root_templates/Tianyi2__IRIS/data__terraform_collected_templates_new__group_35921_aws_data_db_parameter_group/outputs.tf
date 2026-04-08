output "name" {
  description = "DB parameter group name"
  value       = data.aws_db_parameter_group.this.name
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_db_parameter_group.this.region
}

output "arn" {
  description = "ARN of the parameter group"
  value       = data.aws_db_parameter_group.this.arn
}

output "family" {
  description = "Family of the parameter group"
  value       = data.aws_db_parameter_group.this.family
}

output "description" {
  description = "Description of the parameter group"
  value       = data.aws_db_parameter_group.this.description
}