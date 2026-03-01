I'll help create a Terraform configuration for an AWS CodeBuild-based autograder system. This infrastructure will:

1. Create an AWS CodeBuild project that can pull code from GitHub
2. Set up an S3 bucket to store build results/logs
3. Create necessary IAM roles and policies
4. Configure CodeBuild to use a specific runtime environment
5. Enable logging and artifacts storage

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
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
</iac_template>

This Terraform configuration creates:

1. An S3 bucket to store build artifacts and logs
2. IAM role and policy for CodeBuild with necessary permissions
3. A CodeBuild project configured to:
   - Pull code from GitHub
   - Use a Linux container with AWS CodeBuild standard image
   - Store artifacts in S3
   - Log to both CloudWatch and S3
   - Run with a 30-minute timeout
4. A CloudWatch Log Group for build logs

To use this configuration:

1. Make sure you have AWS credentials configured
2. Replace the default GitHub repository URL with your actual repository
3. Create a buildspec.yml file in your GitHub repository that defines the build and test steps
4. The build results will be stored in the created S3 bucket
5. Logs can be monitored in CloudWatch

Note: This configuration assumes the GitHub repository is public. For private repositories, you'll need to add GitHub authentication configuration to the CodeBuild project.