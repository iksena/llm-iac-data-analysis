output "id" {
  description = "Name of the parameter group"
  value       = data.aws_memorydb_parameter_group.this.id
}

output "arn" {
  description = "ARN of the parameter group"
  value       = data.aws_memorydb_parameter_group.this.arn
}

output "description" {
  description = "Description of the parameter group"
  value       = data.aws_memorydb_parameter_group.this.description
}

output "family" {
  description = "Engine version that the parameter group can be used with"
  value       = data.aws_memorydb_parameter_group.this.family
}

output "parameter" {
  description = "Set of user-defined MemoryDB parameters applied by the parameter group"
  value       = data.aws_memorydb_parameter_group.this.parameter
}

output "tags" {
  description = "Map of tags assigned to the parameter group"
  value       = data.aws_memorydb_parameter_group.this.tags
}

output "name" {
  description = "Name of the parameter group"
  value       = data.aws_memorydb_parameter_group.this.name
}

output "region" {
  description = "Region where this resource will be managed"
  value       = data.aws_memorydb_parameter_group.this.region
}