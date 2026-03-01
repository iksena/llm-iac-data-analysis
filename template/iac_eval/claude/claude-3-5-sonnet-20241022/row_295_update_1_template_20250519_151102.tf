provider "aws" {
  region = "us-west-2"
}

# Variables
variable "github_repo_url" {
  description = "GitHub repository URL"
  default     = "https://github.com/example/student-submissions"
}

variable "github_token" {
  description = "GitHub personal access token"
  default     = "dummy-token-replace-me"
}

# S3 bucket for storing results
resource "aws_s3_bucket" "autograder_results" {
  bucket = "autograder-results-${random_string.suffix.result}"
}

resource "aws_s3_bucket_versioning" "autograder_results" {
  bucket = aws_s3_bucket.autograder_results.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Random string for unique naming
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# CloudWatch log group
resource "aws_cloudwatch_log_group" "autograder" {
  name              = "/aws/codebuild/autograder-${random_string.suffix.result}"
  retention_in_days = 14
}

# IAM role for CodeBuild
resource "aws_iam_role" "codebuild" {
  name = "autograder-codebuild-role-${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy for CodeBuild
resource "aws_iam_role_policy" "codebuild" {
  role = aws_iam_role.codebuild.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.autograder_results.arn,
          "${aws_s3_bucket.autograder_results.arn}/*"
        ]
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
      },
      {
        Effect = "Allow"
        Resource = [
          aws_cloudwatch_log_group.autograder.arn,
          "${aws_cloudwatch_log_group.autograder.arn}:*"
        ]
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
      }
    ]
  })
}

# CodeBuild project
resource "aws_codebuild_project" "autograder" {
  name          = "autograder-${random_string.suffix.result}"
  description   = "Autograder for CS class"
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                      = "aws/codebuild/standard:5.0"
    type                       = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "GITHUB"
    location        = var.github_repo_url
    git_clone_depth = 1
    
    git_submodules_config {
      fetch_submodules = true
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.autograder.name
      status     = "ENABLED"
    }
  }
}

# GitHub webhook for CodeBuild
resource "aws_codebuild_webhook" "autograder" {
  project_name = aws_codebuild_project.autograder.name

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }
    filter {
      type    = "HEAD_REF"
      pattern = "main"
    }
  }
}

# Output values
output "s3_bucket_name" {
  value = aws_s3_bucket.autograder_results.id
}

output "codebuild_project_name" {
  value = aws_codebuild_project.autograder.name
}