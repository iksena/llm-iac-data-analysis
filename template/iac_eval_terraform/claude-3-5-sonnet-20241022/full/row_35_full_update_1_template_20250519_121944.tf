I'll help you create a AWS CodeBuild project with an IAM role, environment variables, and no source configuration. This configuration will include:

1. An IAM role and policy for CodeBuild
2. A CodeBuild project with basic configuration
3. Environment variables for the build
4. No source configuration (NONE source type)

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# IAM Role for CodeBuild
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

# IAM Policy for CodeBuild
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
      }
    ]
  })
}

# CodeBuild Project
resource "aws_codebuild_project" "example" {
  name          = "example-project"
  description   = "Example CodeBuild project with no source"
  build_timeout = "30"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                      = "aws/codebuild/standard:5.0"
    type                       = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "EXAMPLE_VAR"
      value = "example_value"
    }

    environment_variable {
      name  = "ENVIRONMENT"
      value = "development"
    }
  }

  source {
    type = "NO_SOURCE"
    buildspec = <<-EOT
      version: 0.2
      phases:
        build:
          commands:
            - echo "This is a placeholder build command"
      EOT
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }

  tags = {
    Environment = "Development"
  }
}
</iac_template>

This Terraform configuration creates:

1. An AWS provider configuration for the us-west-2 region
2. An IAM role that CodeBuild can assume
3. An IAM policy attached to the role with basic CloudWatch Logs permissions
4. A CodeBuild project with:
   - No source configuration (NO_SOURCE type)
   - Two environment variables (EXAMPLE_VAR and ENVIRONMENT)
   - Basic build configuration using the AWS CodeBuild standard image
   - No artifacts output
   - CloudWatch logs enabled
   - A simple buildspec with a placeholder command
   - 30-minute build timeout

The configuration is complete and deployable. All necessary resources are defined, and there are no undefined variables or references. The IAM role has the minimum necessary permissions for CloudWatch Logs, though in a real-world scenario, you might need to add more permissions depending on your build requirements.