output "id" {
  description = "Name of the schedule group"
  value       = aws_scheduler_schedule_group.this.id
}

output "arn" {
  description = "ARN of the schedule group"
  value       = aws_scheduler_schedule_group.this.arn
}

output "creation_date" {
  description = "Time at which the schedule group was created"
  value       = aws_scheduler_schedule_group.this.creation_date
}

output "last_modification_date" {
  description = "Time at which the schedule group was last modified"
  value       = aws_scheduler_schedule_group.this.last_modification_date
}

output "state" {
  description = "State of the schedule group"
  value       = aws_scheduler_schedule_group.this.state
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_scheduler_schedule_group.this.tags_all
}