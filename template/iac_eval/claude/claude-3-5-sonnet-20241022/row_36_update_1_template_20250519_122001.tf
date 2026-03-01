provider "aws" {
  region = "us-west-2"
}

# Variables
variable "github_repo" {
  description = "GitHub repository URL"
  default     = "https://github.com/example/repo"
}

variable "github_branch" {
  description = "GitHub branch"
  default     = "main"
}

# S3 bucket for artifacts and cache
resource "aws_s3_bucket" "codebuild_bucket" {
  bucket = "my-codebuild-artifacts-cache-bucket"
}

resource "aws_s3_bucket_versioning" "codebuild_bucket_versioning" {
  bucket = aws_s3_bucket.codebuild_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# IAM role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-service-role"

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
  name = "codebuild-service-policy"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.codebuild_bucket.arn}",
          "${aws_s3_bucket.codebuild_bucket.arn}/*"
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
        Resource = ["*"]
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
resource "aws_codebuild_project" "project" {
  name          = "example-project"
  description   = "Example CodeBuild project"
  build_timeout = "60"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "S3"
    location = aws_s3_bucket.codebuild_bucket.bucket
  }

  cache {
    type     = "S3"
    location = "${aws_s3_bucket.codebuild_bucket.bucket}/cache"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                      = "aws/codebuild/standard:5.0"
    type                       = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "GITHUB"
    location        = var.github_repo
    git_clone_depth = 1
    buildspec       = "buildspec.yml"

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = var.github_branch

  logs_config {
    cloudwatch_logs {
      group_name  = "example-project-log-group"
      stream_name = "example-project-log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.codebuild_bucket.bucket}/build-logs"
    }
  }

  tags = {
    Environment = "Development"
  }
}