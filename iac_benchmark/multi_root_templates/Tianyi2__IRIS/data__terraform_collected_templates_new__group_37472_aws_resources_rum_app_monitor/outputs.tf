output "arn" {
  description = "The Amazon Resource Name (ARN) specifying the app monitor"
  value       = aws_rum_app_monitor.this.arn
}

output "id" {
  description = "The CloudWatch RUM name as it is the identifier of a RUM"
  value       = aws_rum_app_monitor.this.id
}

output "app_monitor_id" {
  description = "The unique ID of the app monitor. Useful for JS templates"
  value       = aws_rum_app_monitor.this.app_monitor_id
}

output "cw_log_group" {
  description = "The name of the log group where the copies are stored"
  value       = aws_rum_app_monitor.this.cw_log_group
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_rum_app_monitor.this.tags_all
}