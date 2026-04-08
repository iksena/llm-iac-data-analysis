output "arn" {
  description = "The ARN of the monitor."
  value       = aws_networkmonitor_monitor.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_networkmonitor_monitor.this.tags_all
}

output "monitor_name" {
  description = "The name of the monitor."
  value       = aws_networkmonitor_monitor.this.monitor_name
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_networkmonitor_monitor.this.region
}

output "aggregation_period" {
  description = "The time, in seconds, that metrics are aggregated and sent to Amazon CloudWatch."
  value       = aws_networkmonitor_monitor.this.aggregation_period
}

output "tags" {
  description = "Key-value tags for the monitor."
  value       = aws_networkmonitor_monitor.this.tags
}