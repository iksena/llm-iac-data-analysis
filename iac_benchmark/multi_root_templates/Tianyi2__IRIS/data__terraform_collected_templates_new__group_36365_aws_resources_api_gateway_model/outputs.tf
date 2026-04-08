output "id" {
  description = "ID of the model"
  value       = aws_api_gateway_model.this.id
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_api_gateway_model.this.region
}

output "rest_api_id" {
  description = "ID of the associated REST API"
  value       = aws_api_gateway_model.this.rest_api_id
}

output "name" {
  description = "Name of the model"
  value       = aws_api_gateway_model.this.name
}

output "description" {
  description = "Description of the model"
  value       = aws_api_gateway_model.this.description
}

output "content_type" {
  description = "Content type of the model"
  value       = aws_api_gateway_model.this.content_type
}

output "schema" {
  description = "Schema of the model in a JSON form"
  value       = aws_api_gateway_model.this.schema
}