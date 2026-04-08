output "id" {
  description = "The Redshift Scheduled Action name"
  value       = aws_redshift_scheduled_action.this.id
}

output "name" {
  description = "The scheduled action name"
  value       = aws_redshift_scheduled_action.this.name
}

output "description" {
  description = "The description of the scheduled action"
  value       = aws_redshift_scheduled_action.this.description
}

output "enable" {
  description = "Whether the scheduled action is enabled"
  value       = aws_redshift_scheduled_action.this.enable
}

output "start_time" {
  description = "The start time when the schedule is active"
  value       = aws_redshift_scheduled_action.this.start_time
}

output "end_time" {
  description = "The end time when the schedule is active"
  value       = aws_redshift_scheduled_action.this.end_time
}

output "schedule" {
  description = "The schedule of action"
  value       = aws_redshift_scheduled_action.this.schedule
}

output "iam_role" {
  description = "The IAM role ARN used to run the scheduled action"
  value       = aws_redshift_scheduled_action.this.iam_role
}