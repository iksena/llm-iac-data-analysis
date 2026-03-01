I'll help create a Terraform configuration for an autograder system using AWS services. This infrastructure will:

1. Create an S3 bucket to store autograder results
2. Set up an IAM role for CodeBuild with necessary permissions
3. Create a CodeBuild project that can:
   - Pull code from GitHub
   - Run the specified tests
   - Store results in S3
4. Include necessary policies and permissions

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# Variables
variable "github_repo_url" {
  description = "GitHub repository URL"
  default     = "https://github.com/example/student-submissions"
}

variable "github_repo_branch" {
  description = "GitHub repository branch"
  default     = "main"
}

# S3 Bucket for storing autograder results
resource "aws_s3_bucket" "autograder_results" {
  bucket = "cs-class-autograder-results"
}

resource "aws_s3_bucket_versioning" "autograder_results_versioning" {
  bucket = aws_s3_bucket.autograder_results.id
  versioning_configuration {
    status = "Enabled"
  }
}

# IAM Role for CodeBuild
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

# IAM Policy for CodeBuild
resource "aws_iam_role_policy" "codebuild_policy" {
  name = "autograder-codebuild-policy"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.autograder_results.arn}",
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
resource "aws_codebuild_project" "autograder" {
  name          = "cs-class-autograder"
  description   = "Autograder for CS class submissions"
  service_role  = aws_iam_role.codebuild_role.arn
  build_timeout = "30"

  artifacts {
    type = "S3"
    location = aws_s3_bucket.autograder_results.bucket
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
    buildspec       = "buildspec.yml"

    git_submodules_config {
      fetch_submodules = true
    }
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }
}

# CloudWatch Log Group for CodeBuild
resource "aws_cloudwatch_log_group" "autograder_logs" {
  name              = "/aws/codebuild/cs-class-autograder"
  retention_in_days = 30
}
</iac_template>

This Terraform configuration creates:

1. An S3 bucket with versioning enabled to store autograder results
2. An IAM role and policy for CodeBuild with permissions to:
   - Access the S3 bucket
   - Create and manage CloudWatch logs
3. A CodeBuild project that:
   - Pulls code from a specified GitHub repository
   - Runs in a Linux environment with AWS CodeBuild standard image
   - Stores build artifacts in the S3 bucket
   - Logs to CloudWatch
4. A CloudWatch Log Group for storing CodeBuild logs

To use this configuration:

1. Make sure you have AWS credentials configured
2. Update the `github_repo_url` variable with your actual repository URL
3. Create a `buildspec.yml` file in your GitHub repository that defines the actual testing process
4. Configure GitHub authentication for CodeBuild (this needs to be done manually or through GitHub OAuth)

Note: You'll need to create a `buildspec.yml` file in your GitHub repository that defines the actual testing commands and how to store results in S3.