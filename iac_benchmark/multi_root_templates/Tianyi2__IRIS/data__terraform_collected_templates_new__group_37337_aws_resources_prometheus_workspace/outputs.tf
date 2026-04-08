output "arn" {
  description = "Amazon Resource Name (ARN) of the workspace."
  value       = aws_prometheus_workspace.this.arn
}

output "id" {
  description = "Identifier of the workspace."
  value       = aws_prometheus_workspace.this.id
}

output "prometheus_endpoint" {
  description = "Prometheus endpoint available for this workspace."
  value       = aws_prometheus_workspace.this.prometheus_endpoint
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_prometheus_workspace.this.tags_all
}