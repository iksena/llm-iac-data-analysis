output "id" {
  description = "ID of the virtual gateway."
  value       = aws_appmesh_virtual_gateway.this.id
}

output "arn" {
  description = "ARN of the virtual gateway."
  value       = aws_appmesh_virtual_gateway.this.arn
}

output "created_date" {
  description = "Creation date of the virtual gateway."
  value       = aws_appmesh_virtual_gateway.this.created_date
}

output "last_updated_date" {
  description = "Last update date of the virtual gateway."
  value       = aws_appmesh_virtual_gateway.this.last_updated_date
}

output "resource_owner" {
  description = "Resource owner's AWS account ID."
  value       = aws_appmesh_virtual_gateway.this.resource_owner
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_appmesh_virtual_gateway.this.tags_all
}