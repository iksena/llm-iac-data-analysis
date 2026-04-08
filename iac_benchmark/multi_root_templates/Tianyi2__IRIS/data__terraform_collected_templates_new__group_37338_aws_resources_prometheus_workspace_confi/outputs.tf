output "workspace_id" {
  description = "ID of the configured workspace"
  value       = aws_prometheus_workspace_configuration.this.workspace_id
}

output "region" {
  description = "Region where the workspace configuration is managed"
  value       = aws_prometheus_workspace_configuration.this.region
}

output "retention_period_in_days" {
  description = "Number of days to retain metric data in the workspace"
  value       = aws_prometheus_workspace_configuration.this.retention_period_in_days
}

output "limits_per_label_set" {
  description = "Configuration for limits on metrics with specific label sets"
  value       = aws_prometheus_workspace_configuration.this.limits_per_label_set
}