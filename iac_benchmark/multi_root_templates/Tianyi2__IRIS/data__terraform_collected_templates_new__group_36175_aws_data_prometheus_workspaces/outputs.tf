output "aliases" {
  description = "List of aliases of the matched Prometheus workspaces."
  value       = data.aws_prometheus_workspaces.this.aliases
}

output "arns" {
  description = "List of ARNs of the matched Prometheus workspaces."
  value       = data.aws_prometheus_workspaces.this.arns
}

output "workspace_ids" {
  description = "List of workspace IDs of the matched Prometheus workspaces."
  value       = data.aws_prometheus_workspaces.this.workspace_ids
}