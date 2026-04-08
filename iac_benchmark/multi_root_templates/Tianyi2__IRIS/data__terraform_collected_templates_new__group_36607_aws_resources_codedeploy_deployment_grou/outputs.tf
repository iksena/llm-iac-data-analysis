output "arn" {
  description = "The ARN of the CodeDeploy deployment group."
  value       = aws_codedeploy_deployment_group.this.arn
}

output "id" {
  description = "Application name and deployment group name."
  value       = aws_codedeploy_deployment_group.this.id
}

output "compute_platform" {
  description = "The destination platform type for the deployment."
  value       = aws_codedeploy_deployment_group.this.compute_platform
}

output "deployment_group_id" {
  description = "The ID of the CodeDeploy deployment group."
  value       = aws_codedeploy_deployment_group.this.deployment_group_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_codedeploy_deployment_group.this.tags_all
}