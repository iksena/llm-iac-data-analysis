output "id" {
  description = "The ARN of the repository."
  value       = aws_codeartifact_repository.this.id
}

output "arn" {
  description = "The ARN of the repository."
  value       = aws_codeartifact_repository.this.arn
}

output "administrator_account" {
  description = "The account number of the AWS account that manages the repository."
  value       = aws_codeartifact_repository.this.administrator_account
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_codeartifact_repository.this.tags_all
}