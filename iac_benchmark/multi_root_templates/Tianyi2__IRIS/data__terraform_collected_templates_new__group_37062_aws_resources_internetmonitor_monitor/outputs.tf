output "arn" {
  description = "ARN of the Monitor."
  value       = aws_internetmonitor_monitor.this.arn
}

output "id" {
  description = "Name of the monitor."
  value       = aws_internetmonitor_monitor.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_internetmonitor_monitor.this.tags_all
}