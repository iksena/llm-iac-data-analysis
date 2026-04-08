output "id" {
  description = "Workspaces ID."
  value       = data.aws_workspaces_workspace.this.id
}

output "ip_address" {
  description = "IP address of the WorkSpace."
  value       = data.aws_workspaces_workspace.this.ip_address
}

output "computer_name" {
  description = "Name of the WorkSpace, as seen by the operating system."
  value       = data.aws_workspaces_workspace.this.computer_name
}

output "state" {
  description = "Operational state of the WorkSpace."
  value       = data.aws_workspaces_workspace.this.state
}

output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_workspaces_workspace.this.region
}

output "bundle_id" {
  description = "ID of the bundle for the WorkSpace."
  value       = data.aws_workspaces_workspace.this.bundle_id
}

output "directory_id" {
  description = "ID of the directory for the WorkSpace."
  value       = data.aws_workspaces_workspace.this.directory_id
}

output "root_volume_encryption_enabled" {
  description = "Indicates whether the data stored on the root volume is encrypted."
  value       = data.aws_workspaces_workspace.this.root_volume_encryption_enabled
}

output "tags" {
  description = "Tags for the WorkSpace."
  value       = data.aws_workspaces_workspace.this.tags
}

output "user_name" {
  description = "User name of the user for the WorkSpace."
  value       = data.aws_workspaces_workspace.this.user_name
}

output "user_volume_encryption_enabled" {
  description = "Indicates whether the data stored on the user volume is encrypted."
  value       = data.aws_workspaces_workspace.this.user_volume_encryption_enabled
}

output "volume_encryption_key" {
  description = "Symmetric AWS KMS customer master key (CMK) used to encrypt data stored on your WorkSpace."
  value       = data.aws_workspaces_workspace.this.volume_encryption_key
}

output "workspace_id" {
  description = "ID of the WorkSpace."
  value       = data.aws_workspaces_workspace.this.workspace_id
}

output "workspace_properties" {
  description = "WorkSpace properties."
  value       = data.aws_workspaces_workspace.this.workspace_properties
}