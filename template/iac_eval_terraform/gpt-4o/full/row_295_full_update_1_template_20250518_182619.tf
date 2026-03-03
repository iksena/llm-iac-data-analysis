To build and deploy the infrastructure for an autograder for a CS class, we will use AWS services such as S3 for storing the results and CodeBuild for running the students' code. We will also use IAM to manage permissions and roles. The infrastructure will include:

1. An S3 bucket to store the results of the autograder.
2. A CodeBuild project that will pull the students' code from GitHub, execute it in a specified environment, and store the results in the S3 bucket.
3. An IAM role for CodeBuild with permissions to access the S3 bucket and pull code from GitHub.

Below is the Terraform configuration to set up this infrastructure.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "autograder_results" {
  bucket = "cs-class-autograder-results"
  acl    = "private"
}

resource "aws_iam_role" "codebuild_service_role" {
  name = "codebuild-autograder-service-role"

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

resource "aws_iam_policy" "codebuild_policy" {
  name        = "codebuild-autograder-policy"
  description = "Policy for CodeBuild to access S3 and GitHub"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.autograder_results.arn,
          "${aws_s3_bucket.autograder_results.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "codebuild:StartBuild",
          "codebuild:BatchGetBuilds",
          "codebuild:BatchGetProjects"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_policy_attach" {
  role       = aws_iam_role.codebuild_service_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}

resource "aws_codebuild_project" "autograder" {
  name          = "cs-class-autograder"
  service_role  = aws_iam_role.codebuild_service_role.arn

  source {
    type      = "GITHUB"
    location  = "https://github.com/your-org/your-repo"
    buildspec = "buildspec.yml"
  }

  artifacts {
    type = "S3"
    location = aws_s3_bucket.autograder_results.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    environment_variables = [
      {
        name  = "ENV_VAR"
        value = "value"
      }
    ]
  }
}
```
</iac_template>

This configuration sets up an S3 bucket for storing autograder results, a CodeBuild project to run the code, and the necessary IAM roles and policies to allow CodeBuild to access the S3 bucket and GitHub repository. Make sure to replace `"https://github.com/your-org/your-repo"` with the actual GitHub repository URL and update the `buildspec.yml` file as needed for your specific build and test requirements.