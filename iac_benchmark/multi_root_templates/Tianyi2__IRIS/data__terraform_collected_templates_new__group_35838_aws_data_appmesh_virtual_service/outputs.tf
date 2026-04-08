output "arn" {
  description = "ARN of the virtual service."
  value       = data.aws_appmesh_virtual_service.this.arn
}

output "created_date" {
  description = "Creation date of the virtual service."
  value       = data.aws_appmesh_virtual_service.this.created_date
}

output "last_updated_date" {
  description = "Last update date of the virtual service."
  value       = data.aws_appmesh_virtual_service.this.last_updated_date
}

output "resource_owner" {
  description = "Resource owner's AWS account ID."
  value       = data.aws_appmesh_virtual_service.this.resource_owner
}

output "spec" {
  description = "Virtual service specification."
  value       = data.aws_appmesh_virtual_service.this.spec
}

output "tags" {
  description = "Map of tags."
  value       = data.aws_appmesh_virtual_service.this.tags
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_appmesh_virtual_service.this.region
}

output "name" {
  description = "Name of the virtual service."
  value       = data.aws_appmesh_virtual_service.this.name
}

output "mesh_name" {
  description = "Name of the service mesh in which the virtual service exists."
  value       = data.aws_appmesh_virtual_service.this.mesh_name
}

output "mesh_owner" {
  description = "AWS account ID of the service mesh's owner."
  value       = data.aws_appmesh_virtual_service.this.mesh_owner
}