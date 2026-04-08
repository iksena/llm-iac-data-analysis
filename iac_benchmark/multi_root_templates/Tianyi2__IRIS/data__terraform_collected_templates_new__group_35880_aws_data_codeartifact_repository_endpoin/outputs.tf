output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_codeartifact_repository_endpoint.this.region
}

output "domain" {
  description = "Name of the domain that contains the repository."
  value       = data.aws_codeartifact_repository_endpoint.this.domain
}

output "repository" {
  description = "Name of the repository."
  value       = data.aws_codeartifact_repository_endpoint.this.repository
}

output "format" {
  description = "Which endpoint of a repository to return."
  value       = data.aws_codeartifact_repository_endpoint.this.format
}

output "domain_owner" {
  description = "Account number of the AWS account that owns the domain."
  value       = data.aws_codeartifact_repository_endpoint.this.domain_owner
}

output "repository_endpoint" {
  description = "URL of the returned endpoint."
  value       = data.aws_codeartifact_repository_endpoint.this.repository_endpoint
}