I'll help you create a Terraform configuration for an AWS CodeBuild project with the specified requirements. This configuration will include:

1. An AWS CodeBuild project
2. IAM role and policies for CodeBuild
3. GitHub source configuration
4. CloudWatch logs configuration

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
        Resource = [
          "*"
        ]
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
      },
      {
        Effect = "Allow"
        Resource = [
          "*"
        ]
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

# CodeBuild project
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

  logs_config {
    cloudwatch_logs {
      group_name  = "example-codebuild-log-group"
      stream_name = "example-codebuild-log-stream"
      status      = "ENABLED"
    }

    s3_logs {
      status = "DISABLED"
    }
  }

  tags = {
    Environment = "Development"
  }
}
</iac_template>

This Terraform configuration creates:

1. An AWS provider configuration for the us-west-2 region
2. An IAM role with an assume role policy for CodeBuild
3. An IAM policy attached to the role with necessary permissions for CloudWatch Logs and S3
4. A CodeBuild project with:
   - GitHub source configuration
   - Linux container environment
   - CloudWatch logs configuration
   - No artifacts configuration
   - 60-minute build timeout
   - Appropriate tags

To use this configuration:

1. Replace the GitHub repository URL in the source block with your actual repository URL
2. Adjust the IAM permissions in the policy if needed
3. Modify the build environment settings according to your requirements
4. Update the tags as needed

Note that you'll need to have your AWS credentials configured and GitHub connection established in AWS CodeBuild for this to work properly.