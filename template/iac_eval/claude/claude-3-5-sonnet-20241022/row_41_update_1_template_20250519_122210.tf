provider "aws" {
  region = "us-west-2"
}

# S3 bucket for artifacts
resource "aws_s3_bucket" "artifacts" {
  bucket = "my-codebuild-artifacts-bucket"
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

# IAM policy for CodeBuild role
resource "aws_iam_role_policy" "codebuild_policy" {
  role = aws_iam_role.codebuild_role.name

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

# CodeBuild project
resource "aws_codebuild_project" "example" {
  name          = "example-project"
  description   = "Example CodeBuild project"
  build_timeout = "60"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "S3"
    location = aws_s3_bucket.artifacts.bucket
  }

  secondary_artifacts {
    type = "S3"
    location = aws_s3_bucket.artifacts.bucket
    artifact_identifier = "secondary_artifact"
    name = "secondary_build_output"
    packaging = "ZIP"
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/example/primary-repo.git"
    git_clone_depth = 1
    buildspec       = "buildspec.yml"
  }

  secondary_sources {
    type              = "GITHUB"
    location          = "https://github.com/example/secondary-repo.git"
    git_clone_depth   = 1
    source_identifier = "secondary_source"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                      = "aws/codebuild/standard:5.0"
    type                       = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "ENVIRONMENT"
      value = "production"
    }

    environment_variable {
      name  = "API_KEY"
      value = "dummy-api-key"
      type  = "PARAMETER_STORE"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "example-codebuild-log-group"
      stream_name = "example-codebuild-log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.artifacts.id}/build-logs"
    }
  }

  tags = {
    Environment = "Production"
  }
}