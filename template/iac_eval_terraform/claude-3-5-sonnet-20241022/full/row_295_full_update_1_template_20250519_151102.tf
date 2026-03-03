I'll help create a Terraform configuration for an autograding system using AWS services. Here's what we'll build:

1. S3 bucket to store autograding results and student submissions
2. CodeBuild project to run the autograding process
3. IAM roles and policies for CodeBuild
4. GitHub webhook to trigger builds automatically
5. CloudWatch Log group for logging

The system will work as follows:
- When students push code to GitHub, it triggers the CodeBuild project
- CodeBuild pulls the code, runs tests in a controlled environment
- Results are stored in the S3 bucket
- Logs are maintained in CloudWatch

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
</iac_template>

This configuration creates all necessary components for an automated autograding system. Here's what each component does:

1. Creates a unique S3 bucket to store autograding results
2. Sets up a CloudWatch Log group for logging
3. Creates necessary IAM roles and policies for CodeBuild
4. Creates a CodeBuild project that:
   - Uses a standard Linux environment
   - Pulls code from GitHub
   - Stores logs in CloudWatch
   - Can access the S3 bucket to store results
5. Sets up a GitHub webhook to automatically trigger builds on push to main branch

To use this configuration:

1. Replace the `github_repo_url` variable default value with your actual repository URL
2. Replace the `github_token` variable default value with a valid GitHub personal access token
3. The configuration uses random strings to ensure unique resource names
4. Make sure to have a buildspec.yml file in your GitHub repository that defines the actual testing/grading process

The system will automatically run tests when students push code and store results in the S3 bucket, with logs available in CloudWatch for monitoring and debugging.