Below is a description of the Terraform program followed by its complete HCL code.

Description:
This Terraform configuration sets up an AWS CodeBuild project that includes an example IAM role, environment variables, a secondary source, and secondary artifacts. The configuration includes the following resources:
1. An AWS provider configured for the "us-east-1" region.
2. An S3 bucket resource to host the secondary artifacts.
3. An IAM role (with an attached inline policy) that CodeBuild uses to interact with AWS services (e.g., writing logs, accessing S3, etc.).
4. An AWS CodeBuild project that defines:
  • A primary source defined as a GitHub repository.
  • Secondary source(s) defined (example using a Bitbucket repository).
  • Environment variables provided in the environment block.
  • The primary artifacts output as “NO_ARTIFACTS” and a secondary artifact that writes to the S3 bucket defined earlier.
Each resource is fully declared, including any required variables with default values, ensuring the resulting configuration is deployable.

Below is the complete deployable Terraform HCL configuration:

<iac_template>
provider "aws" {
  region = "us-east-1"
}

# S3 bucket for CodeBuild secondary artifacts
resource "aws_s3_bucket" "codebuild_bucket" {
  bucket = "example-codebuild-artifacts-bucket-${random_id.bucket_id.hex}"

  versioning {
    enabled = true
  }

  tags = {
    Name = "CodeBuildArtifactsBucket"
  }
}

# Random id to help ensure unique bucket name
resource "random_id" "bucket_id" {
  byte_length = 4
}

# IAM Role for CodeBuild project with trust policy for CodeBuild service
resource "aws_iam_role" "codebuild_role" {
  name = "example-codebuild-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "codebuild.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "example-codebuild-role"
  }
}

# Inline policy allowing CodeBuild to access CloudWatch logs and S3 artifact bucket
resource "aws_iam_role_policy" "codebuild_policy" {
  name   = "example-codebuild-policy"
  role   = aws_iam_role.codebuild_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:GetBucketLocation"
        ],
        Resource = [
          aws_s3_bucket.codebuild_bucket.arn,
          "${aws_s3_bucket.codebuild_bucket.arn}/*"
        ]
      }
    ]
  })
}

# AWS CodeBuild project with primary source, secondary source, environment variables, and secondary artifacts
resource "aws_codebuild_project" "example" {
  name          = "example-codebuild-project"
  description   = "Example CodeBuild project with IAM role, environment variables, secondary sources, and secondary artifacts"
  service_role  = aws_iam_role.codebuild_role.arn
  build_timeout = 30

  artifacts {
    type = "NO_ARTIFACTS"
  }

  # Secondary artifact writing to the S3 bucket we defined
  secondary_artifacts {
    artifact_identifier = "secondary-artifact-1"
    type                = "S3"
    location            = aws_s3_bucket.codebuild_bucket.bucket
    path                = "artifacts"
    packaging           = "NONE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = false

    environment_variable {
      name  = "EXAMPLE_ENV_VAR"
      value = "example-value"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/myorg/myrepo.git"
    buildspec       = "buildspec.yml"
  }

  # Example secondary source from Bitbucket repository
  secondary_sources {
    source_identifier = "secondary-source-1"
    type              = "BITBUCKET"
    location          = "https://bitbucket.org/myorg/myrepo-second.git"
    git_clone_depth   = 1
  }
}

# (Optional) Random provider for generating id for unique bucket names
provider "random" {}
</iac_template>