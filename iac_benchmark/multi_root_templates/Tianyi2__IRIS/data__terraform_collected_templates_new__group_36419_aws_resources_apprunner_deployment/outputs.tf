output "id" {
  description = "A unique identifier for the deployment."
  value       = aws_apprunner_deployment.this.id
}

output "operation_id" {
  description = "The unique ID of the operation associated with deployment."
  value       = aws_apprunner_deployment.this.operation_id
}

output "status" {
  description = "The current status of the App Runner service deployment."
  value       = aws_apprunner_deployment.this.status
}