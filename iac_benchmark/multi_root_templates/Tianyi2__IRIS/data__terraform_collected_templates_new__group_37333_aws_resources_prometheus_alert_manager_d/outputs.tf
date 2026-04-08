output "id" {
  description = "The ID of the prometheus alert manager definition (workspace_id)"
  value       = aws_prometheus_alert_manager_definition.this.workspace_id
}

output "workspace_id" {
  description = "ID of the prometheus workspace the alert manager definition is linked to"
  value       = aws_prometheus_alert_manager_definition.this.workspace_id
}

output "definition" {
  description = "The alert manager definition that was applied"
  value       = aws_prometheus_alert_manager_definition.this.definition
}

output "region" {
  description = "Region where the resource is managed"
  value       = aws_prometheus_alert_manager_definition.this.region
}