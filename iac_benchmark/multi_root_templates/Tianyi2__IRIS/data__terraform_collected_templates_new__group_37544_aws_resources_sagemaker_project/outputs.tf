output "arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this Project."
  value       = aws_sagemaker_project.this.arn
}

output "id" {
  description = "The name of the Project."
  value       = aws_sagemaker_project.this.id
}

output "project_id" {
  description = "The ID of the project."
  value       = aws_sagemaker_project.this.project_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_sagemaker_project.this.tags_all
}