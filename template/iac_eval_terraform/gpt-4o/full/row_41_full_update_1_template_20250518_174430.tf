To fulfill the business need, we will create an AWS CodeBuild project using Terraform. This project will include an example IAM role with the necessary permissions for CodeBuild to execute. We will also define environment variables, secondary sources, and secondary artifacts for the build project. The configuration will be set up in the `us-east-1` region.

The CodeBuild project will have:
- An IAM role with permissions to access S3, CloudWatch Logs, and CodeBuild.
- Environment variables for the build environment.
- Secondary sources and artifacts to demonstrate how multiple sources and outputs can be managed.

Here is the Terraform HCL configuration:

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
      },
      {
        Effect = "Allow"
        Action = [
          "codebuild:StartBuild",
          "codebuild:StopBuild",
          "codebuild:BatchGetBuilds"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_codebuild_project" "example" {
  name          = "example-codebuild-project"
  service_role  = aws_iam_role.codebuild_role.arn

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    environment_variable {
      name  = "EXAMPLE_ENV_VAR"
      value = "example_value"
    }
  }

  source {
    type      = "GITHUB"
    location  = "https://github.com/example/repo"
  }

  secondary_sources {
    source_identifier = "secondary_source_1"
    type              = "GITHUB"
    location          = "https://github.com/example/secondary-repo"
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  secondary_artifacts {
    artifact_identifier = "secondary_artifact_1"
    type                = "S3"
    location            = "example-bucket"
    path                = "secondary-artifacts/"
    name                = "artifact.zip"
    packaging           = "ZIP"
  }
}
```
</iac_template>