The Terraform program will create an AWS S3 bucket to store the output of a CodeBuild project. The CodeBuild project will be configured to use the S3 bucket for storing build artifacts. The environment for the CodeBuild project will use a small compute type, an Alpine image, and a Linux container. The source for the CodeBuild project will be a GitHub repository with a specified location and a clone depth of 1.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "codebuild_output" {
  bucket = "codebuild-output-bucket-example"
  acl    = "private"
}

resource "aws_iam_role" "codebuild_service_role" {
  name = "codebuild-service-role"

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

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "codebuild-policy"
  role = aws_iam_role.codebuild_service_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:DeleteObject"
        ]
        Resource = "${aws_s3_bucket.codebuild_output.arn}/*"
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

resource "aws_codebuild_project" "student_codebuild" {
  name          = "student-codebuild-project"
  service_role  = aws_iam_role.codebuild_service_role.arn

  artifacts {
    type     = "S3"
    location = aws_s3_bucket.codebuild_output.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/alpine:latest"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/source-location"
    git_clone_depth = 1
  }
}
```
</iac_template>