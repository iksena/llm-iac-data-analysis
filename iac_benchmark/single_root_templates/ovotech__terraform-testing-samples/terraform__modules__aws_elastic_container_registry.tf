# ── main.tf ────────────────────────────────────
resource "aws_ecr_repository" "main" {
  name                 = var.ecr_name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
  }

  tags = {
    ModuleBy = "OVO Tech Production Engineering"
  }
}


# ── variables.tf ────────────────────────────────────
variable "ecr_name" {
  type        = string
  description = "(Required) Name of the elastic container registry being created"
}


# ── outputs.tf ────────────────────────────────────
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


# ── versions.tf ────────────────────────────────────
terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0.1"
    }
  }
}
