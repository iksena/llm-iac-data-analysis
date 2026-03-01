provider "aws" {
  region = "us-east-1"
}

# IAM Role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "example-codebuild-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "codebuild.amazonaws.com"
      }
    }]
  })
}

# Inline policy for CodeBuild role (allows logging to CloudWatch Logs and S3 access for example)
resource "aws_iam_role_policy" "codebuild_policy" {
  name   = "example-codebuild-policy"
  role   = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "*"
      }
    ]
  })
}

# AWS CodeBuild Project
resource "aws_codebuild_project" "example" {
  name          = "example-codebuild-project"
  description   = "An example CodeBuild project with GitHub source and logs configuration"
  service_role  = aws_iam_role.codebuild_role.arn

  # GitHub source configuration
  source {
    type            = "GITHUB"
    location        = "https://github.com/example/example-repo.git"
    buildspec       = "buildspec.yml"
    git_clone_depth = 1
  }

  # Artifacts configuration (output artifacts to CODEPIPELINE mode or NO_ARTIFACTS)
  artifacts {
    type = "NO_ARTIFACTS"
  }

  # Environment configuration (sample Linux container)
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    environment_variable {
      name  = "ENV"
      value = "example"
    }
  }

  # Logs configuration - sends logs to CloudWatch Logs
  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/example"
      stream_name = "example-stream"
    }
  }

  # VPC config is optional. For this example we leave it out.
}

# Optionally, create CloudWatch Logs group if you want to manage it outside CodeBuild project creation
resource "aws_cloudwatch_log_group" "codebuild_log_group" {
  name              = "/aws/codebuild/example"
  retention_in_days = 7
}