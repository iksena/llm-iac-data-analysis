output "service_account_id" {
  description = "Identifier of the service account in the given Grafana workspace"
  value       = aws_grafana_workspace_service_account.this.service_account_id
}