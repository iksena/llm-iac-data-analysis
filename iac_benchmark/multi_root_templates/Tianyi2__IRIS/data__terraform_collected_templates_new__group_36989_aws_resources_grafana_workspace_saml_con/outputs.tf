output "status" {
  description = "The status of the SAML configuration"
  value       = aws_grafana_workspace_saml_configuration.this.status
}