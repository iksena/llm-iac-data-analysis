output "id" {
  description = "The workspaces ID."
  value       = aws_workspaces_workspace.this.id
}

output "ip_address" {
  description = "The IP address of the WorkSpace."
  value       = aws_workspaces_workspace.this.ip_address
}

output "computer_name" {
  description = "The name of the WorkSpace, as seen by the operating system."
  value       = aws_workspaces_workspace.this.computer_name
}

output "state" {
  description = "The operational state of the WorkSpace."
  value       = aws_workspaces_workspace.this.state
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_workspaces_workspace.this.tags_all
}