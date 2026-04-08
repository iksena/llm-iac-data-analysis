output "region" {
  description = "Region where this resource is managed."
  value       = aws_grafana_license_association.this.region
}

output "grafana_token" {
  description = "A token from Grafana Labs that ties your AWS account with a Grafana Labs account."
  value       = aws_grafana_license_association.this.grafana_token
  sensitive   = true
}

output "license_type" {
  description = "The type of license for the workspace license association."
  value       = aws_grafana_license_association.this.license_type
}

output "workspace_id" {
  description = "The workspace id."
  value       = aws_grafana_license_association.this.workspace_id
}

output "free_trial_expiration" {
  description = "If license_type is set to ENTERPRISE_FREE_TRIAL, this is the expiration date of the free trial."
  value       = aws_grafana_license_association.this.free_trial_expiration
}

output "license_expiration" {
  description = "If license_type is set to ENTERPRISE, this is the expiration date of the enterprise license."
  value       = aws_grafana_license_association.this.license_expiration
}