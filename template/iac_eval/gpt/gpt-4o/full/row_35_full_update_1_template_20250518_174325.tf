To fulfill the business need, we will create an AWS CodeBuild project using Terraform. This project will include an example IAM role that grants the necessary permissions for CodeBuild to execute builds. Additionally, we will define an example environment variable for the build environment. Since the requirement specifies "no source," we will configure the CodeBuild project without a source code repository. The configuration will be deployed in the `us-east-1` region.

<iac_template>

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "codebuild_role" {
  name = "example-codebuild-role"

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
  name = "example-codebuild-policy"
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

  artifacts {
    type = "NO_ARTIFACTS"
  }

  source {
    type = "NO_SOURCE"
  }
}
```

</iac_template>