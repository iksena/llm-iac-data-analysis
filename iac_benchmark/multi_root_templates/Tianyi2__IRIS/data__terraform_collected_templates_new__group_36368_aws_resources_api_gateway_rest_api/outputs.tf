output "arn" {
  description = "ARN of the REST API"
  value       = aws_api_gateway_rest_api.this.arn
}

output "created_date" {
  description = "Creation date of the REST API"
  value       = aws_api_gateway_rest_api.this.created_date
}

output "execution_arn" {
  description = "Execution ARN part to be used in lambda_permission's source_arn"
  value       = aws_api_gateway_rest_api.this.execution_arn
}

output "id" {
  description = "ID of the REST API"
  value       = aws_api_gateway_rest_api.this.id
}

output "root_resource_id" {
  description = "Resource ID of the REST API's root"
  value       = aws_api_gateway_rest_api.this.root_resource_id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider"
  value       = aws_api_gateway_rest_api.this.tags_all
}