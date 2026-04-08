output "repo_name" {
  value       = aws_ecr_repository.main.name
  description = "Provided name of the ECR repository."
}

output "repo_uri" {
  value       = aws_ecr_repository.main.repository_url
  description = "The URL of the ECR repo."
}

output "repo_arn" {
  value       = aws_ecr_repository.main.arn
  description = "Full ARN of the repository."
}
