provider "aws" {
  region = "us-west-2"
}

# Variables
variable "github_repo_url" {
  description = "GitHub repository URL"
  type        = string
  default     = "https://github.com/example/student-submissions"
}

variable "github_branch" {
  description = "GitHub branch to build"
  type        = string
  default     = "main"
}

# S3 bucket for build artifacts
resource "aws_s3_bucket" "autograder_artifacts" {
  bucket = "autograder-results-${random_string.suffix.result}"
}

resource "aws_s3_bucket_versioning" "autograder_artifacts" {
  bucket = aws_s3_bucket.autograder_artifacts.id
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

# IAM role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "autograder-codebuild-role"

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
resource "aws_iam_role_policy" "codebuild_policy" {
  name = "autograder-codebuild-policy"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.autograder_artifacts.arn,
          "${aws_s3_bucket.autograder_artifacts.arn}/*"
        ]
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ]
      },
      {
        Effect = "Allow"
        Resource = [
          "*"
        ]
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
      }
    ]
  })
}

# CodeBuild project
resource "aws_codebuild_project" "autograder" {
  name          = "cs-class-autograder"
  description   = "Autograder for CS class submissions"
  build_timeout = "30"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "S3"
    location = aws_s3_bucket.autograder_artifacts.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                      = "aws/codebuild/standard:5.0"
    type                       = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "TEST_ENVIRONMENT"
      value = "true"
    }
  }

  source {
    type            = "GITHUB"
    location        = var.github_repo_url
    git_clone_depth = 1
    buildspec       = "buildspec.yml"

    git_submodules_config {
      fetch_submodules = true
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/autograder"
      stream_name = "build-logs"
      status      = "ENABLED"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.autograder_artifacts.id}/build-logs"
    }
  }
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "autograder" {
  name              = "/aws/codebuild/autograder"
  retention_in_days = 30
}