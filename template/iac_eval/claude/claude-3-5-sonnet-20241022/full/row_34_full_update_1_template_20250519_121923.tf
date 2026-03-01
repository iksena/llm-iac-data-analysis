I'll help you create a Terraform configuration for an AWS CodeBuild project with the specified requirements. This configuration will include:

1. AWS CodeBuild project with GitHub source
2. IAM role and policies for CodeBuild
3. S3 bucket for cache storage
4. Environment variables configuration
5. Necessary provider settings

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

# S3 bucket for cache
resource "aws_s3_bucket" "codebuild_cache" {
  bucket = "my-codebuild-cache-bucket"
}

resource "aws_s3_bucket_versioning" "codebuild_cache" {
  bucket = aws_s3_bucket.codebuild_cache.id
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
  role = aws_iam_role.codebuild_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.codebuild_cache.arn}/*",
          aws_s3_bucket.codebuild_cache.arn
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
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.codebuild_cache.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                      = "aws/codebuild/standard:5.0"
    type                       = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "ENVIRONMENT"
      value = "development"
    }

    environment_variable {
      name  = "API_KEY"
      value = "example-api-key"
    }
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
      status      = "ENABLED"
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
3. An S3 bucket for CodeBuild cache storage with versioning enabled
4. An IAM role and policy for CodeBuild with necessary permissions for S3 and CloudWatch Logs
5. A CodeBuild project with:
   - GitHub source configuration
   - S3 cache configuration
   - Environment variables (ENVIRONMENT and API_KEY)
   - Linux container environment with AWS CodeBuild standard image
   - CloudWatch logs configuration
   - Build timeout of 60 minutes
   - No artifacts configuration (can be modified as needed)

To use this configuration:

1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

Note: You'll need to:
- Replace the default GitHub repository URL with your actual repository
- Adjust the environment variables according to your needs
- Modify the S3 bucket name to be globally unique
- Configure GitHub authentication for CodeBuild separately
- Ensure you have appropriate AWS credentials configured