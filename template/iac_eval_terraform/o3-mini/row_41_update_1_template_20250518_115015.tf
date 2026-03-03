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