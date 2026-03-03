I'll help you create a Terraform configuration for an AWS CodeBuild project with IAM roles, environment variables, secondary sources, and secondary artifacts. This configuration will:

1. Create an IAM role for CodeBuild with necessary permissions
2. Create an S3 bucket for artifacts storage
3. Create a CodeBuild project with:
   - Environment variables
   - Primary and secondary sources from GitHub
   - Primary and secondary artifacts
   - Basic build environment configuration

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# S3 bucket for artifacts
resource "aws_s3_bucket" "artifacts" {
  bucket = "my-codebuild-artifacts-bucket"
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

# IAM policy for CodeBuild role
resource "aws_iam_role_policy" "codebuild_policy" {
  role = aws_iam_role.codebuild_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.artifacts.arn}",
          "${aws_s3_bucket.artifacts.arn}/*"
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
resource "aws_codebuild_project" "example" {
  name          = "example-project"
  description   = "Example CodeBuild project"
  build_timeout = "60"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "S3"
    location = aws_s3_bucket.artifacts.bucket
  }

  secondary_artifacts {
    type = "S3"
    location = aws_s3_bucket.artifacts.bucket
    artifact_identifier = "secondary_artifact"
    name = "secondary_build_output"
    packaging = "ZIP"
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

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                      = "aws/codebuild/standard:5.0"
    type                       = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "ENVIRONMENT"
      value = "production"
    }

    environment_variable {
      name  = "API_KEY"
      value = "dummy-api-key"
      type  = "PARAMETER_STORE"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "example-codebuild-log-group"
      stream_name = "example-codebuild-log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.artifacts.id}/build-logs"
    }
  }

  tags = {
    Environment = "Production"
  }
}
</iac_template>

This Terraform configuration creates:

1. An S3 bucket to store build artifacts
2. An IAM role with necessary permissions for CodeBuild
3. An IAM policy attached to the role
4. A CodeBuild project with:
   - Primary source from GitHub
   - Secondary source from another GitHub repository
   - Primary artifacts stored in S3
   - Secondary artifacts configuration
   - Two environment variables (one regular, one from Parameter Store)
   - Log configuration for both CloudWatch and S3
   - Build environment specifications
   - Build timeout of 60 minutes

To use this configuration:

1. Make sure you have AWS credentials configured
2. Replace the GitHub repository URLs with your actual repositories
3. Adjust the S3 bucket name to be globally unique
4. Modify the environment variables according to your needs
5. Ensure you have the appropriate GitHub authentication configured in AWS CodeBuild

Note: This is a basic example and you might need to add more IAM permissions depending on what your build process needs to access.