provider "aws" {
  region = "us-west-2"
}

# S3 Bucket for artifacts
resource "aws_s3_bucket" "artifacts" {
  bucket = "my-codebuild-artifacts-bucket"
}

resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}

# IAM Role for CodeBuild
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

# IAM Policy for CodeBuild
resource "aws_iam_role_policy" "codebuild_policy" {
  name = "codebuild-service-policy"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.artifacts.arn}",
          "${aws_s3_bucket.artifacts.arn}/*"
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
  description   = "Example CodeBuild project with secondary artifacts"
  build_timeout = "60"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "S3"
    location = aws_s3_bucket.artifacts.id
  }

  secondary_artifacts {
    type = "S3"
    location = aws_s3_bucket.artifacts.id
    artifact_identifier = "secondary_artifact"
    name = "secondary_build_output"
    packaging = "ZIP"
    path = "secondary/"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                      = "aws/codebuild/standard:5.0"
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
            - echo "Hello, World!"
      artifacts:
        files:
          - '**/*'
        secondary-artifacts:
          secondary_artifact:
            files:
              - '**/*'
            base-directory: secondary
    EOT
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "example-codebuild-log-group"
      stream_name = "example-codebuild-log-stream"
    }
  }

  tags = {
    Environment = "Test"
  }
}