output "description" {
  description = "The description of the bundle."
  value       = data.aws_workspaces_bundle.this.description
}

output "bundle_id" {
  description = "The ID of the bundle."
  value       = data.aws_workspaces_bundle.this.bundle_id
}

output "name" {
  description = "The name of the bundle."
  value       = data.aws_workspaces_bundle.this.name
}

output "owner" {
  description = "The owner of the bundle."
  value       = data.aws_workspaces_bundle.this.owner
}

output "compute_type" {
  description = "The compute type."
  value       = data.aws_workspaces_bundle.this.compute_type
}

output "compute_type_name" {
  description = "Name of the compute type."
  value       = data.aws_workspaces_bundle.this.compute_type[0].name
}

output "root_storage" {
  description = "The root volume."
  value       = data.aws_workspaces_bundle.this.root_storage
}

output "root_storage_capacity" {
  description = "Size of the root volume."
  value       = data.aws_workspaces_bundle.this.root_storage[0].capacity
}

output "user_storage" {
  description = "The user storage."
  value       = data.aws_workspaces_bundle.this.user_storage
}

output "user_storage_capacity" {
  description = "Size of the user storage."
  value       = data.aws_workspaces_bundle.this.user_storage[0].capacity
}