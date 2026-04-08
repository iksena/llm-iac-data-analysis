output "id" {
  description = "The identifier of the connection alias."
  value       = aws_workspaces_connection_alias.this.id
}

output "owner_account_id" {
  description = "The identifier of the Amazon Web Services account that owns the connection alias."
  value       = aws_workspaces_connection_alias.this.owner_account_id
}

output "state" {
  description = "The current state of the connection alias."
  value       = aws_workspaces_connection_alias.this.state
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_workspaces_connection_alias.this.tags_all
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_workspaces_connection_alias.this.region
}

output "connection_string" {
  description = "The connection string specified for the connection alias."
  value       = aws_workspaces_connection_alias.this.connection_string
}

output "tags" {
  description = "A map of tags assigned to the WorkSpaces Connection Alias."
  value       = aws_workspaces_connection_alias.this.tags
}