To create a basic AWS CodeBuild project using Terraform, we will define a configuration that includes an AWS CodeBuild project resource. This project will be configured to use a GitHub repository as its source. We will also create an IAM role with the necessary permissions for CodeBuild to access the source code and execute the build. The configuration will include the AWS provider setup, an IAM role with a policy, and the CodeBuild project resource itself.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-example-role"

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
  name = "codebuild-example-policy"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_codebuild_project" "example" {
  name          = "example-codebuild-project"
  service_role  = aws_iam_role.codebuild_role.arn

  source {
    type      = "GITHUB"
    location  = "https://github.com/example/repo.git"
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = false
  }

  build_timeout = 60
}
```
</iac_template>

This configuration sets up a basic AWS CodeBuild project with a GitHub repository as the source. The IAM role and policy provide the necessary permissions for CodeBuild to execute the build and log the output. The project is configured to use a standard AWS CodeBuild image and does not produce any artifacts.