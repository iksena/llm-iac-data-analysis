To fulfill the business need, we will create an AWS CodeBuild project using Terraform. This project will include an IAM role with the necessary permissions, a GitHub source for the build, and a CloudWatch Logs configuration to capture the build logs. The IAM role will have policies that allow CodeBuild to interact with other AWS services as needed. The GitHub source will be configured to pull code from a specified repository, and the logs configuration will ensure that build logs are sent to CloudWatch Logs for monitoring and troubleshooting.

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
  description   = "An example CodeBuild project"

  source {
    type      = "GITHUB"
    location  = "https://github.com/example/repo"
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

  service_role = aws_iam_role.codebuild_role.arn

  logs_config {
    cloudwatch_logs {
      group_name = "example-codebuild-logs"
      stream_name = "example-codebuild-stream"
      status = "ENABLED"
    }
  }
}
```

</iac_template>

This Terraform configuration sets up a CodeBuild project with a GitHub source, an IAM role with the necessary permissions, and a CloudWatch Logs configuration to capture build logs. The IAM role allows CodeBuild to create log groups and streams, put log events, and access S3 objects. The CodeBuild project is configured to use a standard Linux container image.