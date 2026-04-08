output "id" {
  description = "The ID of the API Gateway method response"
  value       = aws_api_gateway_method_response.this.id
}

output "rest_api_id" {
  description = "The string identifier of the associated REST API"
  value       = aws_api_gateway_method_response.this.rest_api_id
}

output "resource_id" {
  description = "The Resource identifier for the method resource"
  value       = aws_api_gateway_method_response.this.resource_id
}

output "http_method" {
  description = "The HTTP verb of the method resource"
  value       = aws_api_gateway_method_response.this.http_method
}

output "status_code" {
  description = "The method response's status code"
  value       = aws_api_gateway_method_response.this.status_code
}

output "response_models" {
  description = "The model resources used for the response's content type"
  value       = aws_api_gateway_method_response.this.response_models
}

output "response_parameters" {
  description = "The response parameters that API Gateway can send back to the caller"
  value       = aws_api_gateway_method_response.this.response_parameters
}