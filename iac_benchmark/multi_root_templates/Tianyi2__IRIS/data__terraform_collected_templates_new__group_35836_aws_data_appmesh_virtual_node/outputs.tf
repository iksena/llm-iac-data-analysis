output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_appmesh_virtual_node.this.region
}

output "name" {
  description = "Name of the virtual node"
  value       = data.aws_appmesh_virtual_node.this.name
}

output "mesh_name" {
  description = "Name of the service mesh in which the virtual node exists"
  value       = data.aws_appmesh_virtual_node.this.mesh_name
}

output "mesh_owner" {
  description = "AWS account ID of the service mesh's owner"
  value       = data.aws_appmesh_virtual_node.this.mesh_owner
}

output "arn" {
  description = "ARN of the virtual node"
  value       = data.aws_appmesh_virtual_node.this.arn
}

output "created_date" {
  description = "Creation date of the virtual node"
  value       = data.aws_appmesh_virtual_node.this.created_date
}

output "last_updated_date" {
  description = "Last update date of the virtual node"
  value       = data.aws_appmesh_virtual_node.this.last_updated_date
}

output "resource_owner" {
  description = "Resource owner's AWS account ID"
  value       = data.aws_appmesh_virtual_node.this.resource_owner
}

output "spec" {
  description = "Virtual node specification"
  value       = data.aws_appmesh_virtual_node.this.spec
}

output "tags" {
  description = "Map of tags"
  value       = data.aws_appmesh_virtual_node.this.tags
}