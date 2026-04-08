output "ecr_url" {
  description = "ECR Repo URL."
  value       = aws_ecr_repository.tomcat_project.repository_url
}
