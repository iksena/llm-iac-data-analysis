output "service_account_token_id" {
  description = "Identifier of the service account token in the given Grafana workspace."
  value       = aws_grafana_workspace_service_account_token.this.service_account_token_id
}

output "created_at" {
  description = "Specifies when the service account token was created."
  value       = aws_grafana_workspace_service_account_token.this.created_at
}

output "expires_at" {
  description = "Specifies when the service account token will expire."
  value       = aws_grafana_workspace_service_account_token.this.expires_at
}

output "key" {
  description = "The key for the service account token. Used when making calls to the Grafana HTTP APIs to authenticate and authorize the requests."
  value       = aws_grafana_workspace_service_account_token.this.key
  sensitive   = true
}