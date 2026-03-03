I'll help you create a Terraform configuration for an AWS CodeBuild project with IAM roles and build batch configuration. This configuration will include:

1. AWS Provider configuration
2. IAM role and policy for CodeBuild
3. CodeBuild project with build batch configuration
4. Required S3 bucket for artifacts

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
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
          "${aws_s3_bucket.codebuild_artifacts.arn}",
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
    type = "S3"
    location = aws_s3_bucket.codebuild_artifacts.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                      = "aws/codebuild/standard:5.0"
    type                       = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/example/example-repo.git"
    git_clone_depth = 1
    buildspec       = "buildspec.yml"
  }

  batch_config {
    service_role = aws_iam_role.codebuild_role.arn
    restrictions {
      compute_types_allowed  = ["BUILD_GENERAL1_SMALL"]
      maximum_builds_allowed = 10
    }
    timeout_in_mins = 120
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "example-codebuild-log-group"
      stream_name = "example-codebuild-log-stream"
      status      = "ENABLED"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.codebuild_artifacts.id}/build-logs"
    }
  }

  tags = {
    Environment = "Development"
  }
}
</iac_template>

This Terraform configuration creates:

1. An S3 bucket for storing CodeBuild artifacts with versioning enabled
2. An IAM role with necessary permissions for CodeBuild to:
   - Access S3 bucket for artifacts
   - Create and manage CloudWatch logs
3. A CodeBuild project with:
   - Build batch configuration
   - GitHub as source provider
   - S3 artifacts configuration
   - CloudWatch and S3 logging enabled
   - Linux container environment with AWS CodeBuild standard image
   - Batch build configuration with restrictions and timeout settings

To use this configuration:

1. Make sure you have AWS credentials configured
2. Update the S3 bucket name to be globally unique
3. Update the GitHub repository URL to your actual repository
4. Adjust the compute type, timeout, and other parameters as needed for your specific use case

The configuration includes all necessary components and permissions for a functional CodeBuild project with batch build capabilities.