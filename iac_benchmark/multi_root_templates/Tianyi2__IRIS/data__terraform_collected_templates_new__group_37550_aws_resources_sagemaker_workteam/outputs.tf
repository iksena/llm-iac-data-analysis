output "arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this Workteam."
  value       = aws_sagemaker_workteam.this.arn
}

output "id" {
  description = "The name of the Workteam."
  value       = aws_sagemaker_workteam.this.id
}

output "subdomain" {
  description = "The subdomain for your OIDC Identity Provider."
  value       = aws_sagemaker_workteam.this.subdomain
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_sagemaker_workteam.this.tags_all
}