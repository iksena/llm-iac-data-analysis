# This resource exports no additional attributes according to the documentation
# However, we can export the computed values for reference

output "id" {
  description = "The ID of the API Gateway Base Path Mapping"
  value       = aws_api_gateway_base_path_mapping.this.id
}

output "domain_name" {
  description = "The domain name of the API Gateway Base Path Mapping"
  value       = aws_api_gateway_base_path_mapping.this.domain_name
}

output "api_id" {
  description = "The API ID of the API Gateway Base Path Mapping"
  value       = aws_api_gateway_base_path_mapping.this.api_id
}

output "stage_name" {
  description = "The stage name of the API Gateway Base Path Mapping"
  value       = aws_api_gateway_base_path_mapping.this.stage_name
}

output "base_path" {
  description = "The base path of the API Gateway Base Path Mapping"
  value       = aws_api_gateway_base_path_mapping.this.base_path
}

output "domain_name_id" {
  description = "The domain name ID of the API Gateway Base Path Mapping"
  value       = aws_api_gateway_base_path_mapping.this.domain_name_id
}