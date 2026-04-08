output "arn" {
  description = "The ARN of the deployment config"
  value       = aws_codedeploy_deployment_config.this.arn
}

output "id" {
  description = "The deployment group's config name"
  value       = aws_codedeploy_deployment_config.this.id
}

output "deployment_config_id" {
  description = "The AWS Assigned deployment config id"
  value       = aws_codedeploy_deployment_config.this.deployment_config_id
}