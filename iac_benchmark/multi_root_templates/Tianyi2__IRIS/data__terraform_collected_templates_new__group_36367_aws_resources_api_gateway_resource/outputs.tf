output "id" {
  description = "Resource's identifier."
  value       = aws_api_gateway_resource.this.id
}

output "path" {
  description = "Complete path for this API resource, including all parent paths."
  value       = aws_api_gateway_resource.this.path
}