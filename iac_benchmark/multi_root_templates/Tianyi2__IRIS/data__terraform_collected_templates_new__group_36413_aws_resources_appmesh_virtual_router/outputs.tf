output "id" {
  description = "ID of the virtual router."
  value       = aws_appmesh_virtual_router.this.id
}

output "arn" {
  description = "ARN of the virtual router."
  value       = aws_appmesh_virtual_router.this.arn
}

output "created_date" {
  description = "Creation date of the virtual router."
  value       = aws_appmesh_virtual_router.this.created_date
}

output "last_updated_date" {
  description = "Last update date of the virtual router."
  value       = aws_appmesh_virtual_router.this.last_updated_date
}

output "resource_owner" {
  description = "Resource owner's AWS account ID."
  value       = aws_appmesh_virtual_router.this.resource_owner
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_appmesh_virtual_router.this.tags_all
}