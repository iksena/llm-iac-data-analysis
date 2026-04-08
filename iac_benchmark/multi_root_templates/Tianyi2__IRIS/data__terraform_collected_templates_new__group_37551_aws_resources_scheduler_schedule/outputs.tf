output "id" {
  description = "Name of the schedule."
  value       = aws_scheduler_schedule.this.id
}

output "arn" {
  description = "ARN of the schedule."
  value       = aws_scheduler_schedule.this.arn
}