To fulfill the business need, we will create an AWS CodeBuild project using Terraform. This project will include an IAM role with the necessary permissions for CodeBuild to execute builds. Additionally, we will configure secondary artifacts for the build project, which can be used to store additional build outputs. The configuration will include a provider setup for AWS in a specified region.

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
          "logs:PutLogEvents",
          "s3:GetObject",
          "s3:PutObject",
          "s3:GetBucketLocation",
          "s3:ListBucket"
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
    location  = "https://github.com/example/repo"
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  secondary_artifacts {
    artifact_identifier = "secondary-artifact-1"
    type                = "S3"
    location            = "my-secondary-artifacts-bucket"
    path                = "build-output/"
    packaging           = "ZIP"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = false
  }

  cache {
    type = "NO_CACHE"
  }

  timeout_in_minutes = 60
}
```

</iac_template>

This Terraform configuration sets up an AWS CodeBuild project with a specified IAM role and secondary artifacts. The IAM role is configured to allow CodeBuild to assume it and perform necessary actions like logging and accessing S3. The CodeBuild project is configured to use a GitHub repository as its source and includes a secondary artifact configuration to store additional build outputs in an S3 bucket.