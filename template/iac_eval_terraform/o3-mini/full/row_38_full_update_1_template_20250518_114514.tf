Description:
This Terraform configuration sets up an AWS CodeBuild project that includes both a primary source and a secondary source. The configuration also creates an example IAM role that CodeBuild assumes to execute builds. The IAM role is granted permissions via an inline policy that allows necessary operations for CodeBuild. The CodeBuild project is configured with an environment, artifact settings, and two source blocks: one for the primary GitHub source repository and one for a secondary GitHub source repository. The configuration includes a valid AWS provider configuration, and all variables have default values.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

# Create an IAM Role for CodeBuild with the proper trust policy
resource "aws_iam_role" "codebuild_role" {
  name = "example-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

# Attach an inline policy to the IAM Role to allow CodeBuild operations
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
          "s3:PutObject"
        ],
        Resource = "*"
      }
    ]
  })
}

# Create the AWS CodeBuild Project with primary and secondary sources
resource "aws_codebuild_project" "example" {
  name          = "example-codebuild-project"
  description   = "CodeBuild project with primary and secondary sources"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = false
  }

  cache {
    type = "NO_CACHE"
  }

  # Primary source definition
  source {
    type      = "GITHUB"
    location  = "https://github.com/example/myrepo.git"
    buildspec = "buildspec.yml"
  }

  # Secondary source definition
  secondary_sources {
    source_identifier = "secondary-source"
    type              = "GITHUB"
    location          = "https://github.com/example/secondaryrepo.git"
    buildspec         = "secondary_buildspec.yml"
  }
}
</iac_template>