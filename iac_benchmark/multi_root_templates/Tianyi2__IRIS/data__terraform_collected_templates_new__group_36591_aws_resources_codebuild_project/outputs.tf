output "arn" {
  description = "ARN of the CodeBuild project."
  value       = aws_codebuild_project.this.arn
}

output "badge_url" {
  description = "URL of the build badge when badge_enabled is enabled."
  value       = aws_codebuild_project.this.badge_url
}

output "id" {
  description = "Name (if imported via name) or ARN (if created via Terraform or imported via ARN) of the CodeBuild project."
  value       = aws_codebuild_project.this.id
}

output "public_project_alias" {
  description = "The project identifier used with the public build APIs."
  value       = aws_codebuild_project.this.public_project_alias
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_codebuild_project.this.tags_all
}