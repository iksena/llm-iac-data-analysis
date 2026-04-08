output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_appmesh_gateway_route.this.region
}

output "name" {
  description = "Name of the gateway route."
  value       = data.aws_appmesh_gateway_route.this.name
}

output "mesh_name" {
  description = "Name of the service mesh in which the virtual gateway exists."
  value       = data.aws_appmesh_gateway_route.this.mesh_name
}

output "virtual_gateway_name" {
  description = "Name of the virtual gateway in which the route exists."
  value       = data.aws_appmesh_gateway_route.this.virtual_gateway_name
}

output "mesh_owner" {
  description = "AWS account ID of the service mesh's owner."
  value       = data.aws_appmesh_gateway_route.this.mesh_owner
}

output "arn" {
  description = "ARN of the gateway route."
  value       = data.aws_appmesh_gateway_route.this.arn
}

output "created_date" {
  description = "Creation date of the gateway route."
  value       = data.aws_appmesh_gateway_route.this.created_date
}

output "last_updated_date" {
  description = "Last update date of the gateway route."
  value       = data.aws_appmesh_gateway_route.this.last_updated_date
}

output "resource_owner" {
  description = "Resource owner's AWS account ID."
  value       = data.aws_appmesh_gateway_route.this.resource_owner
}

output "spec" {
  description = "Gateway route specification."
  value       = data.aws_appmesh_gateway_route.this.spec
}

output "tags" {
  description = "Map of tags."
  value       = data.aws_appmesh_gateway_route.this.tags
}