output "key" {
  description = "The key token in JSON format. Use this value as a bearer token to authenticate HTTP requests to the workspace."
  value       = aws_grafana_workspace_api_key.this.key
  sensitive   = true
}