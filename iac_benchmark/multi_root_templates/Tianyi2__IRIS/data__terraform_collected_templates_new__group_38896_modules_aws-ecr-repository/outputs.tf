output "ecr_repository_arn" {
  value = aws_ecr_repository.this.arn
}

output "ecr_repository_url" {
  value = aws_ecr_repository.this.repository_url
}

output "ecr_repository_id" {
  value = aws_ecr_repository.this.registry_id
}

output "ecr_repository_name" {
  value = aws_ecr_repository.this.name
}

output "deployment_permission_set" {
  description = "Minimal requirements required to push to this repository using AWS Actions"
  value       = data.aws_iam_policy_document.deployment_requirements
}
