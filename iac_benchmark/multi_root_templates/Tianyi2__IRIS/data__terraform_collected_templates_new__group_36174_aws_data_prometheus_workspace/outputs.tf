output "arn" {
  description = "ARN of the Prometheus workspace."
  value       = data.aws_prometheus_workspace.this.arn
}

output "created_date" {
  description = "Creation date of the Prometheus workspace."
  value       = data.aws_prometheus_workspace.this.created_date
}

output "prometheus_endpoint" {
  description = "Endpoint of the Prometheus workspace."
  value       = data.aws_prometheus_workspace.this.prometheus_endpoint
}

output "alias" {
  description = "Prometheus workspace alias."
  value       = data.aws_prometheus_workspace.this.alias
}

output "kms_key_arn" {
  description = "ARN of the KMS key used to encrypt data in the Prometheus workspace."
  value       = data.aws_prometheus_workspace.this.kms_key_arn
}

output "status" {
  description = "Status of the Prometheus workspace."
  value       = data.aws_prometheus_workspace.this.status
}

output "tags" {
  description = "Tags assigned to the resource."
  value       = data.aws_prometheus_workspace.this.tags
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_prometheus_workspace.this.region
}

output "workspace_id" {
  description = "Prometheus workspace ID."
  value       = data.aws_prometheus_workspace.this.workspace_id
}