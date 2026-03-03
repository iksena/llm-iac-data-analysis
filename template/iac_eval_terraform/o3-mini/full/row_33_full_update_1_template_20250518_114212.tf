Description:
This Terraform configuration creates a basic AWS CodeBuild project. It first sets up an AWS provider in the us-east-1 region. An IAM role (and inline policy) is created with a trust relationship that allows CodeBuild to assume the role and permissions to write logs to CloudWatch. The CodeBuild project resource is then defined using GitHub as its source (an example repository URL is provided), with a simple buildspec for demonstration purposes and a basic Linux container environment.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "codebuild_role" {
  name = "example_codebuild_role"
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Principal : {
          Service : "codebuild.amazonaws.com"
        },
        Action : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "example_codebuild_policy"
  role = aws_iam_role.codebuild_role.id
  
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource : "*"
      }
    ]
  })
}

resource "aws_codebuild_project" "example" {
  name         = "example-codebuild-project"
  description  = "Example CodeBuild project using GitHub as source"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = false
  }

  source {
    type     = "GITHUB"
    location = "https://github.com/example/repo.git"
    buildspec = <<EOF
version: 0.2

phases:
  build:
    commands:
      - echo "Building the project..."
EOF
  }

  timeout_in_minutes = 30
}
</iac_template>