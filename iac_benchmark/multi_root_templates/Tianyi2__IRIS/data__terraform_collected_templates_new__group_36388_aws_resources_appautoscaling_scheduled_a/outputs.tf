output "arn" {
  description = "ARN of the scheduled action."
  value       = aws_appautoscaling_scheduled_action.this.arn
}

output "name" {
  description = "Name of the scheduled action."
  value       = aws_appautoscaling_scheduled_action.this.name
}

output "service_namespace" {
  description = "Namespace of the AWS service."
  value       = aws_appautoscaling_scheduled_action.this.service_namespace
}

output "resource_id" {
  description = "Identifier of the resource associated with the scheduled action."
  value       = aws_appautoscaling_scheduled_action.this.resource_id
}

output "scalable_dimension" {
  description = "Scalable dimension."
  value       = aws_appautoscaling_scheduled_action.this.scalable_dimension
}

output "schedule" {
  description = "Schedule for this action."
  value       = aws_appautoscaling_scheduled_action.this.schedule
}

output "start_time" {
  description = "Date and time for the scheduled action to start."
  value       = aws_appautoscaling_scheduled_action.this.start_time
}

output "end_time" {
  description = "Date and time for the scheduled action to end."
  value       = aws_appautoscaling_scheduled_action.this.end_time
}

output "timezone" {
  description = "Time zone used when setting a scheduled action."
  value       = aws_appautoscaling_scheduled_action.this.timezone
}