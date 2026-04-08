output "region" {
  description = "Region where this resource is managed"
  value       = aws_api_gateway_documentation_version.this.region
}

output "version" {
  description = "Version identifier of the API documentation snapshot"
  value       = aws_api_gateway_documentation_version.this.version
}

output "rest_api_id" {
  description = "ID of the associated Rest API"
  value       = aws_api_gateway_documentation_version.this.rest_api_id
}

output "description" {
  description = "Description of the API documentation version"
  value       = aws_api_gateway_documentation_version.this.description
}