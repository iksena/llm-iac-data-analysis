provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "autograder_results" {
  bucket = "cs-class-autograder-results"
  acl    = "private"

  tags = {
    Name        = "CS Class Autograder Results"
    Environment = "Production"
  }
}

resource "aws_iam_role" "codebuild_service_role" {
  name = "codebuild-autograder-service-role"

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
          aws_s3_bucket.autograder_results.arn,
          "${aws_s3_bucket.autograder_results.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_policy_attach" {
  role       = aws_iam_role.codebuild_service_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}

resource "aws_codebuild_project" "autograder" {
  name          = "CS-Class-Autograder"
  service_role  = aws_iam_role.codebuild_service_role.arn
  source {
    type      = "GITHUB"
    location  = "https://github.com/your-org/your-repo"
    buildspec = "buildspec.yml"
  }

  artifacts {
    type = "S3"
    location = aws_s3_bucket.autograder_results.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    environment_variables = [
      {
        name  = "GITHUB_TOKEN"
        value = "your-github-token"
        type  = "PLAINTEXT"
      }
    ]
  }

  tags = {
    Name        = "CS Class Autograder"
    Environment = "Production"
  }
}