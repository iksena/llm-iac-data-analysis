output "arn" {
  description = "ARN assigned by AWS to the autoscaling schedule"
  value       = aws_autoscaling_schedule.this.arn
}

output "autoscaling_group_name" {
  description = "The name of the Auto Scaling group"
  value       = aws_autoscaling_schedule.this.autoscaling_group_name
}

output "scheduled_action_name" {
  description = "The name of this scaling action"
  value       = aws_autoscaling_schedule.this.scheduled_action_name
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_autoscaling_schedule.this.region
}

output "desired_capacity" {
  description = "The initial capacity of the Auto Scaling group after the scheduled action runs"
  value       = aws_autoscaling_schedule.this.desired_capacity
}

output "end_time" {
  description = "The date and time for the recurring schedule to end"
  value       = aws_autoscaling_schedule.this.end_time
}

output "max_size" {
  description = "The maximum size of the Auto Scaling group"
  value       = aws_autoscaling_schedule.this.max_size
}

output "min_size" {
  description = "The minimum size of the Auto Scaling group"
  value       = aws_autoscaling_schedule.this.min_size
}

output "recurrence" {
  description = "The recurring schedule for this action"
  value       = aws_autoscaling_schedule.this.recurrence
}

output "start_time" {
  description = "The date and time for the recurring schedule to start"
  value       = aws_autoscaling_schedule.this.start_time
}

output "time_zone" {
  description = "The time zone for a cron expression"
  value       = aws_autoscaling_schedule.this.time_zone
}