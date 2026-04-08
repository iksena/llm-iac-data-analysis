output "arn" {
  description = "The Amazon Resource Name (ARN) of the Grafana workspace"
  value       = aws_grafana_workspace.this.arn
}

output "endpoint" {
  description = "The endpoint of the Grafana workspace"
  value       = aws_grafana_workspace.this.endpoint
}

output "grafana_version" {
  description = "The version of Grafana running on the workspace"
  value       = aws_grafana_workspace.this.grafana_version
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_grafana_workspace.this.tags_all
}