output "name" {
  description = "Name of the ECR Repository"
  value       = data.aws_ecr_repository.this.name
}

output "registry_id" {
  description = "Registry ID where the repository was created"
  value       = data.aws_ecr_repository.this.registry_id
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_ecr_repository.this.region
}

output "arn" {
  description = "Full ARN of the repository"
  value       = data.aws_ecr_repository.this.arn
}

output "encryption_configuration" {
  description = "Encryption configuration for the repository"
  value       = data.aws_ecr_repository.this.encryption_configuration
}

output "image_scanning_configuration" {
  description = "Configuration block that defines image scanning configuration for the repository"
  value       = data.aws_ecr_repository.this.image_scanning_configuration
}

output "image_tag_mutability" {
  description = "The tag mutability setting for the repository"
  value       = data.aws_ecr_repository.this.image_tag_mutability
}

output "image_tag_mutability_exclusion_filter" {
  description = "Block that defines filters to specify which image tags can override the default tag mutability setting"
  value       = data.aws_ecr_repository.this.image_tag_mutability_exclusion_filter
}

output "most_recent_image_tags" {
  description = "List of image tags associated with the most recently pushed image in the repository"
  value       = data.aws_ecr_repository.this.most_recent_image_tags
}

output "repository_url" {
  description = "URL of the repository"
  value       = data.aws_ecr_repository.this.repository_url
}

output "tags" {
  description = "Map of tags assigned to the resource"
  value       = data.aws_ecr_repository.this.tags
}