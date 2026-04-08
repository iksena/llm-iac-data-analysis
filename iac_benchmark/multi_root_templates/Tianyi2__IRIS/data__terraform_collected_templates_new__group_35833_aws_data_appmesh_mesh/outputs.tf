output "arn" {
  description = "ARN of the service mesh."
  value       = data.aws_appmesh_mesh.this.arn
}

output "created_date" {
  description = "Creation date of the service mesh."
  value       = data.aws_appmesh_mesh.this.created_date
}

output "last_updated_date" {
  description = "Last update date of the service mesh."
  value       = data.aws_appmesh_mesh.this.last_updated_date
}

output "resource_owner" {
  description = "Resource owner's AWS account ID."
  value       = data.aws_appmesh_mesh.this.resource_owner
}

output "spec" {
  description = "Service mesh specification."
  value       = data.aws_appmesh_mesh.this.spec
}

output "tags" {
  description = "Map of tags."
  value       = data.aws_appmesh_mesh.this.tags
}