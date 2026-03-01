To fulfill the business need, we will create an AWS CodeBuild project using Terraform. This project will include an IAM role with the necessary permissions, a GitHub source for the build, an S3 bucket for storing build artifacts, and a local cache for build operations. The configuration will be set up in the `us-east-1` region.

The IAM role will have policies that allow CodeBuild to interact with S3 and GitHub. The source will be a GitHub repository, and the artifacts will be stored in an S3 bucket. The cache will be configured to use local storage to speed up build times.

Here is the Terraform configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "codebuild_artifacts" {
  bucket = "my-codebuild-artifacts-bucket"
  acl    = "private"
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
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.codebuild_artifacts.arn,
          "${aws_s3_bucket.codebuild_artifacts.arn}/*"
        ]
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

resource "aws_codebuild_project" "example" {
  name          = "example-codebuild-project"
  service_role  = aws_iam_role.codebuild_role.arn

  source {
    type            = "GITHUB"
    location        = "https://github.com/example/repo.git"
    git_clone_depth = 1
  }

  artifacts {
    type  = "S3"
    location = aws_s3_bucket.codebuild_artifacts.bucket
    packaging = "ZIP"
  }

  cache {
    type = "LOCAL"
    modes = ["LOCAL_SOURCE_CACHE", "LOCAL_DOCKER_LAYER_CACHE"]
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }
}
```
</iac_template>

This configuration sets up a CodeBuild project with a GitHub source, S3 artifacts, and a local cache. The IAM role and policy ensure that the project has the necessary permissions to perform its tasks.