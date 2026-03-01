provider "aws" {
  region = "us-east-1"
}

# A random suffix for the S3 bucket name to ensure uniqueness.
resource "random_id" "bucket_rand" {
  byte_length = 4
}

# Create an S3 bucket for storing CodeBuild artifacts.
resource "aws_s3_bucket" "codebuild_artifacts" {
  bucket = "tf-codebuild-artifacts-example-${random_id.bucket_rand.hex}"
  acl    = "private"

  tags = {
    Name = "CodeBuildArtifactsBucket"
  }
}

# IAM Role for CodeBuild.
resource "aws_iam_role" "codebuild_role" {
  name = "example-codebuild-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

# Inline IAM Policy for CodeBuild to allow access to CloudWatch Logs and the S3 bucket.
resource "aws_iam_role_policy" "codebuild_policy" {
  name = "example-codebuild-policy"
  role = aws_iam_role.codebuild_role.id

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
          "s3:ListBucket",
          "s3:PutObject",
          "s3:PutObjectAcl"
        ],
        Resource = [
          aws_s3_bucket.codebuild_artifacts.arn,
          "${aws_s3_bucket.codebuild_artifacts.arn}/*"
        ]
      }
    ]
  })
}

# AWS CodeBuild project with GitHub source, S3 artifact storage, and local cache configuration.
resource "aws_codebuild_project" "example" {
  name        = "example-codebuild-project"
  description = "A sample CodeBuild project configured with GitHub source, S3 artifact storage, and local cache"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type     = "S3"
    location = aws_s3_bucket.codebuild_artifacts.bucket
    packaging = "ZIP"
    path      = "artifacts"
  }

  source {
    type      = "GITHUB"
    location  = "https://github.com/example/myrepo.git"
    buildspec = "buildspec.yml"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_SOURCE_CACHE", "LOCAL_DOCKER_LAYER_CACHE"]
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:4.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "EXAMPLE_ENV"
      value = "example"
    }
  }

  tags = {
    Project = "ExampleCodeBuild"
  }
}