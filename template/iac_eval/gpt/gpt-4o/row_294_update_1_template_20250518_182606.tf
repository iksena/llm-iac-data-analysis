provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "autograder_bucket" {
  bucket = "cs-class-autograder-results"
  acl    = "private"
}

resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-autograder-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "codebuild_policy" {
  name        = "codebuild-autograder-policy"
  description = "Policy for CodeBuild to access S3 and GitHub"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.autograder_bucket.arn,
          "${aws_s3_bucket.autograder_bucket.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_policy_attach" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}

resource "aws_codebuild_project" "autograder_project" {
  name          = "CSClassAutograder"
  description   = "CodeBuild project for CS class autograder"
  build_timeout = 5

  source {
    type      = "GITHUB"
    location  = "https://github.com/your-org/your-repo"
    buildspec = "buildspec.yml"
  }

  artifacts {
    type = "S3"
    location = aws_s3_bucket.autograder_bucket.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    environment_variables = [
      {
        name  = "ENV_VAR"
        value = "value"
      }
    ]
  }

  service_role = aws_iam_role.codebuild_role.arn
}