output "id" {
  description = "AWS Region."
  value       = data.aws_ecr_repositories.this.id
}

output "names" {
  description = "A list of AWS Elastic Container Registries for the region."
  value       = data.aws_ecr_repositories.this.names
}