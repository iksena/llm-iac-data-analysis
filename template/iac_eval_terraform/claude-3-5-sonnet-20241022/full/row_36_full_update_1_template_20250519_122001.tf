I'll help you create a Terraform configuration for an AWS CodeBuild project with GitHub source integration, artifacts configuration, and caching. This configuration will include:

1. AWS CodeBuild project
2. IAM role and policies for CodeBuild
3. GitHub source configuration
4. S3 artifact configuration
5. S3 cache configuration

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
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
</iac_template>

This Terraform configuration creates:

1. An AWS provider configuration for the us-west-2 region
2. Variables for GitHub repository URL and branch
3. An S3 bucket for artifacts and cache storage
4. An IAM role and policy for CodeBuild with necessary permissions
5. A CodeBuild project with:
   - GitHub source configuration
   - S3 artifacts configuration
   - S3 cache configuration
   - Environment configuration using the standard AWS CodeBuild image
   - Logging configuration for both CloudWatch and S3
   - Build timeout of 60 minutes
   - Tags for resource management

To use this configuration:

1. Replace the default GitHub repository URL with your actual repository
2. Adjust the region if needed
3. Modify the S3 bucket name to ensure it's globally unique
4. Customize the build environment, compute type, and timeout as needed
5. Ensure your GitHub repository contains a valid buildspec.yml file

Note that you'll need to configure GitHub authentication separately in the AWS CodeBuild console or through AWS CLI for the GitHub source to work properly.