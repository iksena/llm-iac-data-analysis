output "applied_for" {
  description = "Which features this template applies to. Contains one or more of PULL_THROUGH_CACHE or REPLICATION."
  value       = data.aws_ecr_repository_creation_template.this.applied_for
}

output "custom_role_arn" {
  description = "The ARN of the custom role used for repository creation."
  value       = data.aws_ecr_repository_creation_template.this.custom_role_arn
}

output "description" {
  description = "The description for this template."
  value       = data.aws_ecr_repository_creation_template.this.description
}

output "encryption_configuration" {
  description = "Encryption configuration for any created repositories."
  value       = data.aws_ecr_repository_creation_template.this.encryption_configuration
}

output "image_tag_mutability" {
  description = "The tag mutability setting for any created repositories."
  value       = data.aws_ecr_repository_creation_template.this.image_tag_mutability
}

output "image_tag_mutability_exclusion_filter" {
  description = "Block that defines filters to specify which image tags can override the default tag mutability setting."
  value       = data.aws_ecr_repository_creation_template.this.image_tag_mutability_exclusion_filter
}

output "lifecycle_policy" {
  description = "The lifecycle policy document to apply to any created repositories."
  value       = data.aws_ecr_repository_creation_template.this.lifecycle_policy
}

output "registry_id" {
  description = "The registry ID the repository creation template applies to."
  value       = data.aws_ecr_repository_creation_template.this.registry_id
}

output "repository_policy" {
  description = "The registry policy document to apply to any created repositories."
  value       = data.aws_ecr_repository_creation_template.this.repository_policy
}

output "resource_tags" {
  description = "A map of tags to assign to any created repositories."
  value       = data.aws_ecr_repository_creation_template.this.resource_tags
}