output "arn" {
  description = "ARN of the route"
  value       = data.aws_appmesh_route.this.arn
}

output "created_date" {
  description = "Creation date of the route"
  value       = data.aws_appmesh_route.this.created_date
}

output "last_updated_date" {
  description = "Last update date of the route"
  value       = data.aws_appmesh_route.this.last_updated_date
}

output "resource_owner" {
  description = "Resource owner's AWS account ID"
  value       = data.aws_appmesh_route.this.resource_owner
}

output "spec" {
  description = "Route specification"
  value       = data.aws_appmesh_route.this.spec
}

output "tags" {
  description = "Map of tags"
  value       = data.aws_appmesh_route.this.tags
}

output "name" {
  description = "Name of the route"
  value       = data.aws_appmesh_route.this.name
}

output "mesh_name" {
  description = "Name of the service mesh in which the virtual router exists"
  value       = data.aws_appmesh_route.this.mesh_name
}

output "virtual_router_name" {
  description = "Name of the virtual router in which the route exists"
  value       = data.aws_appmesh_route.this.virtual_router_name
}

output "mesh_owner" {
  description = "AWS account ID of the service mesh's owner"
  value       = data.aws_appmesh_route.this.mesh_owner
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_appmesh_route.this.region
}