I'll help you create a Terraform configuration for an AWS CodeBuild project with IAM roles and secondary sources. This configuration will:

1. Create an IAM role and policy for CodeBuild
2. Create a CodeBuild project with:
   - Primary source from GitHub
   - Secondary source from another GitHub repository
   - Basic build environment configuration
   - Necessary permissions to execute builds

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
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

# IAM policy for CodeBuild
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
  description   = "Example CodeBuild project with secondary sources"
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

  logs_config {
    cloudwatch_logs {
      group_name  = "example-codebuild-log-group"
      stream_name = "example-codebuild-log-stream"
      status      = "ENABLED"
    }
  }

  tags = {
    Environment = "Development"
  }
}
</iac_template>

This Terraform configuration creates:

1. An IAM role that CodeBuild can assume
2. An IAM policy attached to the role with basic permissions for CloudWatch Logs and S3
3. A CodeBuild project with:
   - Primary source from GitHub
   - Secondary source from another GitHub repository
   - Linux container environment
   - CloudWatch logs configuration
   - 60-minute build timeout
   - No artifacts configuration (can be modified as needed)

To use this configuration:

1. Replace the GitHub repository URLs in the source and secondary_sources blocks with your actual repository URLs
2. Adjust the IAM permissions in the policy if your build needs additional AWS services
3. Modify the build environment settings if you need a different compute type or container image
4. Ensure you have the appropriate GitHub authentication configured in AWS CodeBuild

Note: This is a basic configuration and you might need to add more permissions to the IAM role depending on what your build process needs to access.