output "id" {
  description = "The ID of the Gateway Response."
  value       = aws_api_gateway_gateway_response.this.id
}

output "rest_api_id" {
  description = "The ID of the associated REST API."
  value       = aws_api_gateway_gateway_response.this.rest_api_id
}

output "response_type" {
  description = "The response type of the Gateway Response."
  value       = aws_api_gateway_gateway_response.this.response_type
}