To build and deploy the infrastructure for an autograder using AWS CodeBuild, we will create a Terraform configuration that sets up the necessary AWS resources. This includes an S3 bucket for storing build artifacts and results, an IAM role with the necessary permissions for CodeBuild, and a CodeBuild project that pulls code from a GitHub repository. The CodeBuild project will be configured to run a buildspec file that defines the environment and commands needed to execute the students' code.

Here is the Terraform configuration:

1. **AWS Provider**: Configure the AWS provider to use a specific region.
2. **S3 Bucket**: Create an S3 bucket to store the build artifacts and results.
3. **IAM Role and Policy**: Create an IAM role with a policy that allows CodeBuild to access the S3 bucket and GitHub.
4. **CodeBuild Project**: Define a CodeBuild project that specifies the source as a GitHub repository and uses a buildspec file to run the autograder.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "autograder_bucket" {
  bucket = "cs-class-autograder-results"
  acl    = "private"
}

resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-autograder-role"

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
          aws_s3_bucket.autograder_bucket.arn,
          "${aws_s3_bucket.autograder_bucket.arn}/*"
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

resource "aws_iam_role_policy_attachment" "codebuild_policy_attach" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}

resource "aws_codebuild_project" "autograder_project" {
  name          = "CSClassAutograder"
  description   = "CodeBuild project for CS class autograder"
  build_timeout = 5

  source {
    type      = "GITHUB"
    location  = "https://github.com/your-org/your-repo"
    buildspec = "buildspec.yml"
  }

  artifacts {
    type = "S3"
    location = aws_s3_bucket.autograder_bucket.bucket
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

  service_role = aws_iam_role.codebuild_role.arn
}
```
</iac_template>

This configuration sets up the necessary AWS resources to run an autograder using AWS CodeBuild. The CodeBuild project is configured to pull code from a specified GitHub repository and execute it in a defined environment. The results are stored in an S3 bucket. The IAM role and policy ensure that CodeBuild has the necessary permissions to perform its tasks.