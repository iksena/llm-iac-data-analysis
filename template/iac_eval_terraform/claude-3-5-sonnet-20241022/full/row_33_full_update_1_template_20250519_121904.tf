I'll help you create a Terraform configuration for an AWS CodeBuild project with GitHub as the source and the necessary IAM roles. This configuration will include:

1. AWS Provider configuration
2. IAM role and policies for CodeBuild
3. CodeBuild project with GitHub source
4. Required variables with default values

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# IAM role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "example-codebuild-role"

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
  name = "example-codebuild-policy"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Resource = ["*"]
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
      },
      {
        Effect = "Allow"
        Resource = ["*"]
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
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
    location        = "https://github.com/example/repository.git"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "main"

  logs_config {
    cloudwatch_logs {
      group_name  = "example-log-group"
      stream_name = "example-log-stream"
    }
  }

  tags = {
    Environment = "Test"
  }
}

# Variables with default values
variable "github_location" {
  description = "GitHub repository URL"
  type        = string
  default     = "https://github.com/example/repository.git"
}

variable "build_timeout" {
  description = "Build timeout in minutes"
  type        = string
  default     = "60"
}

variable "environment_compute_type" {
  description = "Build environment compute type"
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}
</iac_template>

This Terraform configuration creates:

1. An AWS provider configured for the us-west-2 region
2. An IAM role with the necessary trust policy for CodeBuild
3. An IAM policy attached to the role with basic permissions for CloudWatch Logs and S3
4. A CodeBuild project with:
   - GitHub as the source
   - Linux container environment
   - CloudWatch logs configuration
   - No artifacts configuration
   - Basic build settings

The configuration includes variables with default values for flexibility. To use this configuration:

1. Replace the GitHub repository URL with your actual repository URL
2. Adjust the IAM permissions based on your specific needs
3. Modify the build environment and other settings as required
4. Make sure you have appropriate GitHub authentication configured in AWS CodeBuild

Note that you'll need to have AWS credentials configured and appropriate permissions to create these resources. Also, you might need to configure GitHub authentication in AWS CodeBuild separately, as this is not handled by the Terraform configuration.