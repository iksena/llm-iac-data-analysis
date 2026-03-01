provider "aws" {
  region = "us-west-2"
}

# S3 bucket for CodeBuild artifacts
resource "aws_s3_bucket" "codebuild_artifacts" {
  bucket = "my-codebuild-artifacts-bucket-12345"
}

resource "aws_s3_bucket_versioning" "codebuild_artifacts_versioning" {
  bucket = aws_s3_bucket.codebuild_artifacts.id
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

# IAM policy for the CodeBuild role
resource "aws_iam_role_policy" "codebuild_policy" {
  name = "codebuild-service-policy"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.codebuild_artifacts.arn,
          "${aws_s3_bucket.codebuild_artifacts.arn}/*"
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

# CodeBuild Project
resource "aws_codebuild_project" "example" {
  name          = "example-project"
  description   = "Example CodeBuild project"
  build_timeout = "60"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type     = "NO_ARTIFACTS"
  }

  cache {
    type = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                      = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                       = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "NO_SOURCE"
    buildspec       = <<-EOT
      version: 0.2
      phases:
        build:
          commands:
            - echo "Hello, CodeBuild!"
    EOT
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      status  = "ENABLED"
      location = "${aws_s3_bucket.codebuild_artifacts.id}/build-logs"
    }
  }

  batch_config {
    service_role = aws_iam_role.codebuild_role.arn
    combine_artifacts = false
    restrictions {
      compute_types_allowed  = ["BUILD_GENERAL1_SMALL"]
      maximum_builds_allowed = 10
    }
    timeout_in_mins = 120
  }

  tags = {
    Environment = "Development"
  }
}