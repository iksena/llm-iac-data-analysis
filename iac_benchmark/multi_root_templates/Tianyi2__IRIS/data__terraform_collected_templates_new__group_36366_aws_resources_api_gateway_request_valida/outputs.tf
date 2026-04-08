output "id" {
  description = "Unique ID of the request validator"
  value       = aws_api_gateway_request_validator.this.id
}

output "name" {
  description = "Name of the request validator"
  value       = aws_api_gateway_request_validator.this.name
}

output "rest_api_id" {
  description = "ID of the associated Rest API"
  value       = aws_api_gateway_request_validator.this.rest_api_id
}

output "validate_request_body" {
  description = "Boolean whether to validate request body"
  value       = aws_api_gateway_request_validator.this.validate_request_body
}

output "validate_request_parameters" {
  description = "Boolean whether to validate request parameters"
  value       = aws_api_gateway_request_validator.this.validate_request_parameters
}