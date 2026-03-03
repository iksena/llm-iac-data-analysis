This Terraform configuration provisions an AWS CodeBuild project that does not have a source repository (using the "NO_SOURCE" type) and produces no artifacts ("NO_ARTIFACTS" type). The project is configured with an environment containing an example environment variable. An IAM role appropriate for CodeBuild is created with the necessary trust relationship, and a managed IAM policy is attached for permissions.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "codebuild_role" {
  name = "example_codebuild_role"

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

resource "aws_iam_role_policy_attachment" "codebuild_role_attachment" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
}

resource "aws_codebuild_project" "example" {
  name         = "example-codebuild-project"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "EXAMPLE_VAR"
      value = "example_value"
    }
  }

  source {
    type = "NO_SOURCE"
  }
}
</iac_template>