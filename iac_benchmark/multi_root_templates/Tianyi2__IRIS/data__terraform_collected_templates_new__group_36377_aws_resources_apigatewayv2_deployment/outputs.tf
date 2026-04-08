output "id" {
  description = "Deployment identifier."
  value       = aws_apigatewayv2_deployment.this.id
}

output "auto_deployed" {
  description = "Whether the deployment was automatically released."
  value       = aws_apigatewayv2_deployment.this.auto_deployed
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_apigatewayv2_deployment.this.region
}

output "api_id" {
  description = "API identifier."
  value       = aws_apigatewayv2_deployment.this.api_id
}

output "description" {
  description = "Description for the deployment resource."
  value       = aws_apigatewayv2_deployment.this.description
}

output "triggers" {
  description = "Map of arbitrary keys and values that trigger redeployment."
  value       = aws_apigatewayv2_deployment.this.triggers
}