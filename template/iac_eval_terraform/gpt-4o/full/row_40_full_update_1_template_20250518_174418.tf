To create an AWS CodeBuild project with a build batch configuration, we need to define a Terraform configuration that includes the AWS provider, an IAM role with the necessary permissions for CodeBuild, and the CodeBuild project itself. The IAM role will have a policy that allows CodeBuild to perform necessary actions. The build batch configuration will be included in the CodeBuild project resource.

Below is the Terraform HCL configuration for this setup:

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
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_codebuild_project" "example" {
  name          = "example-codebuild-project"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = false
  }

  source {
    type      = "GITHUB"
    location  = "https://github.com/example/repo"
  }

  build_batch_config {
    service_role = aws_iam_role.codebuild_role.arn

    combine_artifacts = true

    restrictions {
      maximum_builds_allowed = 5
    }

    timeout_in_mins = 60
  }
}
```
</iac_template>

This configuration sets up an AWS CodeBuild project with a build batch configuration. The IAM role and policy allow CodeBuild to access necessary AWS services. The build batch configuration specifies the service role, artifact combination, build restrictions, and timeout settings.