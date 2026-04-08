output "account_access_type" {
  description = "Type of account access for the workspace."
  value       = data.aws_grafana_workspace.this.account_access_type
}

output "authentication_providers" {
  description = "Authentication providers for the workspace."
  value       = data.aws_grafana_workspace.this.authentication_providers
}

output "arn" {
  description = "ARN of the Grafana workspace."
  value       = data.aws_grafana_workspace.this.arn
}

output "created_date" {
  description = "Creation date of the Grafana workspace."
  value       = data.aws_grafana_workspace.this.created_date
}

output "data_sources" {
  description = "Data sources for the workspace."
  value       = data.aws_grafana_workspace.this.data_sources
}

output "description" {
  description = "Workspace description."
  value       = data.aws_grafana_workspace.this.description
}

output "endpoint" {
  description = "Endpoint of the Grafana workspace."
  value       = data.aws_grafana_workspace.this.endpoint
}

output "grafana_version" {
  description = "Version of Grafana running on the workspace."
  value       = data.aws_grafana_workspace.this.grafana_version
}

output "last_updated_date" {
  description = "Last updated date of the Grafana workspace."
  value       = data.aws_grafana_workspace.this.last_updated_date
}

output "name" {
  description = "Grafana workspace name."
  value       = data.aws_grafana_workspace.this.name
}

output "notification_destinations" {
  description = "The notification destinations."
  value       = data.aws_grafana_workspace.this.notification_destinations
}

output "organization_role_name" {
  description = "The role name that the workspace uses to access resources through Amazon Organizations."
  value       = data.aws_grafana_workspace.this.organization_role_name
}

output "organizational_units" {
  description = "The Amazon Organizations organizational units that the workspace is authorized to use data sources from."
  value       = data.aws_grafana_workspace.this.organizational_units
}

output "permission_type" {
  description = "Permission type of the workspace."
  value       = data.aws_grafana_workspace.this.permission_type
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_grafana_workspace.this.region
}

output "role_arn" {
  description = "IAM role ARN that the workspace assumes."
  value       = data.aws_grafana_workspace.this.role_arn
}

output "stack_set_name" {
  description = "AWS CloudFormation stack set name that provisions IAM roles to be used by the workspace."
  value       = data.aws_grafana_workspace.this.stack_set_name
}

output "status" {
  description = "Status of the Grafana workspace."
  value       = data.aws_grafana_workspace.this.status
}

output "tags" {
  description = "Tags assigned to the resource."
  value       = data.aws_grafana_workspace.this.tags
}

output "workspace_id" {
  description = "Grafana workspace ID."
  value       = data.aws_grafana_workspace.this.workspace_id
}