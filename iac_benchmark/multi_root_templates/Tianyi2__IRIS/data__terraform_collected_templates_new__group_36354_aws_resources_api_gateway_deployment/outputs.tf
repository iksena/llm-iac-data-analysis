output "id" {
  description = "ID of the deployment"
  value       = aws_api_gateway_deployment.this.id
}

output "created_date" {
  description = "Creation date of the deployment"
  value       = aws_api_gateway_deployment.this.created_date
}