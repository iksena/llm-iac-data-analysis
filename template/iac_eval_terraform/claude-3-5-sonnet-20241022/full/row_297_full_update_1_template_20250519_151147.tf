I'll help you create a Terraform configuration that sets up an AWS CodeBuild project with an S3 bucket for storing build artifacts. The configuration will include:

1. AWS Provider configuration
2. S3 bucket for storing build artifacts
3. IAM role and policies for CodeBuild
4. CodeBuild project with specified environment and source configurations

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Create S3 bucket for build artifacts
resource "aws_s3_bucket" "codebuild_artifacts" {
  bucket = "student-codebuild-artifacts-bucket"
}

# Enable versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "codebuild_artifacts_versioning" {
  bucket = aws_s3_bucket.codebuild_artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create IAM role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "student-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

# Create IAM policy for CodeBuild
resource "aws_iam_role_policy" "codebuild_policy" {
  name = "student-codebuild-policy"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.codebuild_artifacts.arn,
          "${aws_s3_bucket.codebuild_artifacts.arn}/*"
        ]
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ]
      },
      {
        Effect = "Allow"
        Resource = ["*"]
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
      }
    ]
  })
}

# Create CodeBuild project
resource "aws_codebuild_project" "student_project" {
  name          = "student-build-project"
  description   = "Student CodeBuild project"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type     = "S3"
    location = aws_s3_bucket.codebuild_artifacts.id
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                      = "alpine"
    type                       = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "GITHUB"
    location        = "github.com/source-location"
    git_clone_depth = 1
  }
}
</iac_template>

This Terraform configuration creates:
1. An AWS S3 bucket to store CodeBuild artifacts with versioning enabled
2. An IAM role and policy that allows CodeBuild to access the S3 bucket and create CloudWatch logs
3. A CodeBuild project with:
   - S3 artifacts configuration pointing to the created bucket
   - Environment using BUILD_GENERAL1_SMALL compute type, alpine image, and LINUX_CONTAINER type
   - GitHub source configuration with specified location and clone depth

Note: You'll need to:
1. Replace "student-codebuild-artifacts-bucket" with a globally unique bucket name
2. Update the GitHub location to your actual repository URL
3. Configure GitHub authentication for CodeBuild (this may require additional setup in the AWS Console)
4. Ensure you have appropriate AWS credentials configured to apply this Terraform configuration