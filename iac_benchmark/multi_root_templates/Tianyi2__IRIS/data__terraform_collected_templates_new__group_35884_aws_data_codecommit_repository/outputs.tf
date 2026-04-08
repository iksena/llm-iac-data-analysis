output "repository_id" {
  description = "ID of the repository."
  value       = data.aws_codecommit_repository.this.repository_id
}

output "kms_key_id" {
  description = "The ID of the encryption key."
  value       = data.aws_codecommit_repository.this.kms_key_id
}

output "arn" {
  description = "ARN of the repository."
  value       = data.aws_codecommit_repository.this.arn
}

output "clone_url_http" {
  description = "URL to use for cloning the repository over HTTPS."
  value       = data.aws_codecommit_repository.this.clone_url_http
}

output "clone_url_ssh" {
  description = "URL to use for cloning the repository over SSH."
  value       = data.aws_codecommit_repository.this.clone_url_ssh
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_codecommit_repository.this.region
}

output "repository_name" {
  description = "Name for the repository."
  value       = data.aws_codecommit_repository.this.repository_name
}