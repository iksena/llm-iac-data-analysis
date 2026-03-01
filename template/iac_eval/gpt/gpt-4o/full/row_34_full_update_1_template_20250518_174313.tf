To fulfill the business need, we will create an AWS CodeBuild project using Terraform. This project will include an IAM role with the necessary permissions, a GitHub source repository, environment variables, and a cache configuration. The IAM role will allow CodeBuild to interact with other AWS services. The GitHub source will specify the repository to be used for the build, and the environment variables will be used to configure the build environment. The cache will be configured to store intermediate build artifacts to speed up subsequent builds.

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
          "s3:PutObject"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_codebuild_project" "example" {
  name          = "example-codebuild-project"
  description   = "An example CodeBuild project"

  source {
    type      = "GITHUB"
    location  = "https://github.com/example/repo"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    environment_variable {
      name  = "EXAMPLE_ENV_VAR"
      value = "example_value"
    }
  }

  service_role = aws_iam_role.codebuild_role.arn

  cache {
    type     = "S3"
    location = "my-codebuild-cache-bucket"
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }
}

resource "aws_s3_bucket" "codebuild_cache" {
  bucket = "my-codebuild-cache-bucket"
  acl    = "private"
}
```

</iac_template>