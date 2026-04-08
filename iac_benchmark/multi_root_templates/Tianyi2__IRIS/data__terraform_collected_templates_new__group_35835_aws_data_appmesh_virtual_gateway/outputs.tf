output "arn" {
  description = "ARN of the virtual gateway."
  value       = data.aws_appmesh_virtual_gateway.this.arn
}

output "created_date" {
  description = "Creation date of the virtual gateway."
  value       = data.aws_appmesh_virtual_gateway.this.created_date
}

output "last_updated_date" {
  description = "Last update date of the virtual gateway."
  value       = data.aws_appmesh_virtual_gateway.this.last_updated_date
}

output "resource_owner" {
  description = "Resource owner's AWS account ID."
  value       = data.aws_appmesh_virtual_gateway.this.resource_owner
}

output "spec" {
  description = "Virtual gateway specification."
  value       = data.aws_appmesh_virtual_gateway.this.spec
}

output "tags" {
  description = "Map of tags."
  value       = data.aws_appmesh_virtual_gateway.this.tags
}

output "name" {
  description = "Name of the virtual gateway."
  value       = data.aws_appmesh_virtual_gateway.this.name
}

output "mesh_name" {
  description = "Name of the service mesh in which the virtual gateway exists."
  value       = data.aws_appmesh_virtual_gateway.this.mesh_name
}

output "mesh_owner" {
  description = "AWS account ID of the service mesh's owner."
  value       = data.aws_appmesh_virtual_gateway.this.mesh_owner
}

output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_appmesh_virtual_gateway.this.region
}