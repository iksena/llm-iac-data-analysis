output "arn" {
  description = "ARN of the Scheduled Query."
  value       = aws_timestreamquery_scheduled_query.this.arn
}

output "creation_time" {
  description = "Creation time for the scheduled query."
  value       = aws_timestreamquery_scheduled_query.this.creation_time
}

output "next_invocation_time" {
  description = "Next time the scheduled query is scheduled to run."
  value       = aws_timestreamquery_scheduled_query.this.next_invocation_time
}

output "previous_invocation_time" {
  description = "Last time the scheduled query was run."
  value       = aws_timestreamquery_scheduled_query.this.previous_invocation_time
}

output "state" {
  description = "State of the scheduled query, either ENABLED or DISABLED."
  value       = aws_timestreamquery_scheduled_query.this.state
}

output "last_run_summary" {
  description = "Runtime summary for the last scheduled query run."
  value       = aws_timestreamquery_scheduled_query.this.last_run_summary
}

output "recently_failed_runs" {
  description = "Runtime summary for the last five failed scheduled query runs."
  value       = aws_timestreamquery_scheduled_query.this.recently_failed_runs
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_timestreamquery_scheduled_query.this.tags_all
}