output "api_key_source" {
  description = "Source of the API key for requests."
  value       = data.aws_api_gateway_rest_api.this.api_key_source
}

output "arn" {
  description = "ARN of the REST API."
  value       = data.aws_api_gateway_rest_api.this.arn
}

output "binary_media_types" {
  description = "List of binary media types supported by the REST API."
  value       = data.aws_api_gateway_rest_api.this.binary_media_types
}

output "description" {
  description = "Description of the REST API."
  value       = data.aws_api_gateway_rest_api.this.description
}

output "endpoint_configuration" {
  description = "The endpoint configuration of this RestApi showing the endpoint types of the API."
  value       = data.aws_api_gateway_rest_api.this.endpoint_configuration
}

output "execution_arn" {
  description = "Execution ARN part to be used in lambda_permission's source_arn when allowing API Gateway to invoke a Lambda function."
  value       = data.aws_api_gateway_rest_api.this.execution_arn
}

output "id" {
  description = "ID of the found REST API."
  value       = data.aws_api_gateway_rest_api.this.id
}

output "minimum_compression_size" {
  description = "Minimum response size to compress for the REST API."
  value       = data.aws_api_gateway_rest_api.this.minimum_compression_size
}

output "name" {
  description = "Name of the REST API."
  value       = data.aws_api_gateway_rest_api.this.name
}

output "policy" {
  description = "JSON formatted policy document that controls access to the API Gateway."
  value       = data.aws_api_gateway_rest_api.this.policy
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_api_gateway_rest_api.this.region
}

output "root_resource_id" {
  description = "ID of the API Gateway Resource on the found REST API where the route matches '/'."
  value       = data.aws_api_gateway_rest_api.this.root_resource_id
}

output "tags" {
  description = "Key-value map of resource tags."
  value       = data.aws_api_gateway_rest_api.this.tags
}