To build the infrastructure for an autograder for a CS class, we will use AWS services. The autograder will run students' code stored on GitHub using AWS CodeBuild, and the results will be stored in an AWS S3 bucket. We will create an S3 bucket to store the results of the autograder. An AWS CodeBuild project will be set up to pull the code from GitHub, execute it in a specified environment, and then store the results in the S3 bucket. We will also create an IAM role with the necessary permissions for CodeBuild to access the S3 bucket and GitHub.

Here is the Terraform configuration:

<iac_template>
```hcl
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
```
</iac_template>

This configuration sets up an S3 bucket for storing autograder results, an IAM role with the necessary permissions, and a CodeBuild project that pulls code from GitHub, runs it, and stores the results in the S3 bucket. Make sure to replace `"https://github.com/your-org/your-repo"` and `"your-github-token"` with your actual GitHub repository URL and token.