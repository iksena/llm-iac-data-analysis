output "id" {
  description = "ID of the found Resource"
  value       = data.aws_api_gateway_resource.this.id
}

output "parent_id" {
  description = "ID of the parent Resource"
  value       = data.aws_api_gateway_resource.this.parent_id
}

output "path_part" {
  description = "Path relative to the parent Resource"
  value       = data.aws_api_gateway_resource.this.path_part
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_api_gateway_resource.this.region
}

output "rest_api_id" {
  description = "REST API id that owns the resource"
  value       = data.aws_api_gateway_resource.this.rest_api_id
}

output "path" {
  description = "Full path of the resource"
  value       = data.aws_api_gateway_resource.this.path
}