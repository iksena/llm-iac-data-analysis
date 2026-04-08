output "arn" {
  description = "ARN of the virtual router"
  value       = data.aws_appmesh_virtual_router.this.arn
}

output "created_date" {
  description = "Creation date of the virtual router"
  value       = data.aws_appmesh_virtual_router.this.created_date
}

output "last_updated_date" {
  description = "Last update date of the virtual router"
  value       = data.aws_appmesh_virtual_router.this.last_updated_date
}

output "resource_owner" {
  description = "Resource owner's AWS account ID"
  value       = data.aws_appmesh_virtual_router.this.resource_owner
}

output "spec" {
  description = "Virtual router specification"
  value       = data.aws_appmesh_virtual_router.this.spec
}

output "tags" {
  description = "Map of tags"
  value       = data.aws_appmesh_virtual_router.this.tags
}