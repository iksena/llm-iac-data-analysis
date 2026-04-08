output "id" {
  description = "ID of the service mesh."
  value       = aws_appmesh_mesh.this.id
}

output "arn" {
  description = "ARN of the service mesh."
  value       = aws_appmesh_mesh.this.arn
}

output "created_date" {
  description = "Creation date of the service mesh."
  value       = aws_appmesh_mesh.this.created_date
}

output "last_updated_date" {
  description = "Last update date of the service mesh."
  value       = aws_appmesh_mesh.this.last_updated_date
}

output "mesh_owner" {
  description = "AWS account ID of the service mesh's owner."
  value       = aws_appmesh_mesh.this.mesh_owner
}

output "resource_owner" {
  description = "Resource owner's AWS account ID."
  value       = aws_appmesh_mesh.this.resource_owner
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_appmesh_mesh.this.tags_all
}