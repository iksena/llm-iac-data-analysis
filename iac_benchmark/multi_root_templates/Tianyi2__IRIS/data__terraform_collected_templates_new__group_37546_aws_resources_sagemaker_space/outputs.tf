output "arn" {
  description = "The space's Amazon Resource Name (ARN)."
  value       = aws_sagemaker_space.this.arn
}

output "home_efs_file_system_uid" {
  description = "The ID of the space's profile in the Amazon Elastic File System volume."
  value       = aws_sagemaker_space.this.home_efs_file_system_uid
}

output "id" {
  description = "The space's Amazon Resource Name (ARN)."
  value       = aws_sagemaker_space.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_sagemaker_space.this.tags_all
}

output "url" {
  description = "Returns the URL of the space. If the space is created with Amazon Web Services IAM Identity Center authentication, users can navigate to the URL after appending the respective redirect parameter for the application type to be federated through Amazon Web Services IAM Identity Center."
  value       = aws_sagemaker_space.this.url
}