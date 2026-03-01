To build the infrastructure for an autograder for a CS class, we will use AWS services such as S3, CodeBuild, and VPC. The autograder will run students' code stored on GitHub in a secure environment and store the results in an S3 bucket. To ensure that the students' code does not reach the internet, we will configure a VPC with private subnets and a security group that restricts outbound internet access. We will also set up an IAM role for CodeBuild to access the necessary resources.

Here's a description of the Terraform configuration:

1. **AWS Provider Configuration**: Set up the AWS provider to deploy resources in a specific region.
2. **VPC Configuration**: Create a VPC with private subnets to ensure that the CodeBuild environment does not have internet access.
3. **S3 Bucket**: Create an S3 bucket to store the autograder results.
4. **IAM Role and Policy**: Create an IAM role with a policy that allows CodeBuild to access the S3 bucket and other necessary resources.
5. **CodeBuild Project**: Set up a CodeBuild project that pulls code from GitHub, runs the autograder, and stores the results in the S3 bucket.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "autograder_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.autograder_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = false
}

resource "aws_security_group" "no_internet" {
  vpc_id = aws_vpc.autograder_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = []
  }
}

resource "aws_s3_bucket" "autograder_results" {
  bucket = "autograder-results-bucket"
  acl    = "private"
}

resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-autograder-role"

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

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "codebuild-autograder-policy"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.autograder_results.arn}/*"
      }
    ]
  })
}

resource "aws_codebuild_project" "autograder" {
  name          = "autograder-project"
  service_role  = aws_iam_role.codebuild_role.arn
  source {
    type      = "GITHUB"
    location  = "https://github.com/your-org/your-repo"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = false
    environment_variable {
      name  = "S3_BUCKET"
      value = aws_s3_bucket.autograder_results.bucket
    }
  }
  vpc_config {
    vpc_id            = aws_vpc.autograder_vpc.id
    subnets           = [aws_subnet.private_subnet.id]
    security_group_ids = [aws_security_group.no_internet.id]
  }
  artifacts {
    type = "NO_ARTIFACTS"
  }
}
```
</iac_template>