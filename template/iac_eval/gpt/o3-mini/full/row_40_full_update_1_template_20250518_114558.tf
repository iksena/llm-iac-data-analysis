Description:
This Terraform configuration deploys an AWS CodeBuild project that has build batch configuration enabled. It creates an IAM role with the proper assume role policy for CodeBuild and attaches the AWS managed policy "AWSCodeBuildAdminAccess" to grant the necessary permissions. The CodeBuild project is configured with a simple GitHub source, no-artifacts output, and basic Linux container environment settings. The build batch configuration is specified within the project using a separate block that includes parameters such as timeout values and batch report mode.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "codebuild" {
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

resource "aws_iam_role_policy_attachment" "codebuild_attachment" {
  role       = aws_iam_role.codebuild.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"
}

resource "aws_codebuild_project" "example" {
  name          = "example-codebuild-project"
  description   = "Example CodeBuild project with build batch configuration"
  service_role  = aws_iam_role.codebuild.arn
  build_timeout = 30

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type     = "GITHUB"
    location = "https://github.com/example/example-repo.git"
  }

  build_batch_config {
    service_role               = aws_iam_role.codebuild.arn
    timeout_in_minutes         = 60
    queued_timeout_in_minutes  = 30
    batch_report_mode          = "REPORT_AGGREGATED_BATCHES"
  }
}
</iac_template>