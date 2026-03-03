provider "aws" {
  region = "us-west-2"
}

# S3 bucket to hold secondary artifacts from CodeBuild
resource "aws_s3_bucket" "codebuild_artifacts" {
  bucket = "codebuild-artifacts-example-${random_id.bucket_suffix.hex}"
  acl    = "private"
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# IAM role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "example-codebuild-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codebuild.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM role inline policy to allow S3 actions on the artifacts bucket
resource "aws_iam_role_policy" "codebuild_role_policy" {
  name = "codebuild-artifacts-policy"
  role = aws_iam_role.codebuild_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:GetBucketLocation"
        ]
        Resource = [
          aws_s3_bucket.codebuild_artifacts.arn,
          "${aws_s3_bucket.codebuild_artifacts.arn}/*"
        ]
      }
    ]
  })
}

# CodeBuild project with secondary artifact defined
resource "aws_codebuild_project" "example" {
  name          = "example-codebuild-project"
  description   = "Example CodeBuild project with secondary artifacts"
  build_timeout = 10

  # Reference the IAM role created above
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  secondary_artifacts {
    artifact_identifier     = "secondaryArtifact1"
    type                    = "S3"
    location                = aws_s3_bucket.codebuild_artifacts.bucket
    packaging               = "ZIP"
    override_artifact_name  = true
    name                    = "secondary-artifact-output"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = false
  }

  source {
    type      = "GITHUB"
    location  = "https://github.com/example/repo.git"
    buildspec = "buildspec.yml"
  }
}