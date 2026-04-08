output "repository_id" {
  description = "The ID of the repository"
  value       = aws_codecommit_repository.this.repository_id
}

output "arn" {
  description = "The ARN of the repository"
  value       = aws_codecommit_repository.this.arn
}

output "clone_url_http" {
  description = "The URL to use for cloning the repository over HTTPS"
  value       = aws_codecommit_repository.this.clone_url_http
}

output "clone_url_ssh" {
  description = "The URL to use for cloning the repository over SSH"
  value       = aws_codecommit_repository.this.clone_url_ssh
}

output "repository_name" {
  description = "The name for the repository"
  value       = aws_codecommit_repository.this.repository_name
}

output "description" {
  description = "The description of the repository"
  value       = aws_codecommit_repository.this.description
}

output "default_branch" {
  description = "The default branch of the repository"
  value       = aws_codecommit_repository.this.default_branch
}

output "kms_key_id" {
  description = "The ARN of the encryption key"
  value       = aws_codecommit_repository.this.kms_key_id
}

output "tags" {
  description = "Key-value map of resource tags"
  value       = aws_codecommit_repository.this.tags
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_codecommit_repository.this.tags_all
}