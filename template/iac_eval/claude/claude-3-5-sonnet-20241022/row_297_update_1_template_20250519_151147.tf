provider "aws" {
  region = "us-west-2"
}

# Create S3 bucket for build artifacts
resource "aws_s3_bucket" "codebuild_artifacts" {
  bucket = "student-codebuild-artifacts-bucket"
}

# Enable versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "codebuild_artifacts_versioning" {
  bucket = aws_s3_bucket.codebuild_artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create IAM role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "student-codebuild-role"

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

# Create IAM policy for CodeBuild
resource "aws_iam_role_policy" "codebuild_policy" {
  name = "student-codebuild-policy"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.codebuild_artifacts.arn,
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

# Create CodeBuild project
resource "aws_codebuild_project" "student_project" {
  name          = "student-build-project"
  description   = "Student CodeBuild project"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type     = "S3"
    location = aws_s3_bucket.codebuild_artifacts.id
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                      = "alpine"
    type                       = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "GITHUB"
    location        = "github.com/source-location"
    git_clone_depth = 1
  }
}