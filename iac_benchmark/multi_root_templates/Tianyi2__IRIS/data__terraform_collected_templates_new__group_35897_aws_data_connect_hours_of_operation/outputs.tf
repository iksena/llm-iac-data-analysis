output "arn" {
  description = "ARN of the Hours of Operation"
  value       = data.aws_connect_hours_of_operation.this.arn
}

output "config" {
  description = "Configuration information for the hours of operation: day, start time, and end time"
  value       = data.aws_connect_hours_of_operation.this.config
}

output "description" {
  description = "Description of the Hours of Operation"
  value       = data.aws_connect_hours_of_operation.this.description
}

output "hours_of_operation_id" {
  description = "The identifier for the hours of operation"
  value       = data.aws_connect_hours_of_operation.this.hours_of_operation_id
}

output "instance_id" {
  description = "Identifier of the hosting Amazon Connect Instance"
  value       = data.aws_connect_hours_of_operation.this.instance_id
}

output "name" {
  description = "Name of the Hours of Operation"
  value       = data.aws_connect_hours_of_operation.this.name
}

output "tags" {
  description = "Map of tags to assign to the Hours of Operation"
  value       = data.aws_connect_hours_of_operation.this.tags
}

output "time_zone" {
  description = "Time zone of the Hours of Operation"
  value       = data.aws_connect_hours_of_operation.this.time_zone
}