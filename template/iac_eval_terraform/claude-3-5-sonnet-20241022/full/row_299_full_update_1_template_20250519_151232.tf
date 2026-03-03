I'll help create a Terraform configuration for an autograder system that securely runs and evaluates student code submissions. Here's the design:

1. VPC with private subnets (no internet access) for running CodeBuild projects
2. S3 bucket to store grading results
3. CodeBuild project running in the VPC to execute and grade student code
4. IAM roles and policies for necessary permissions
5. VPC Endpoints to allow CodeBuild to access S3 and GitHub without internet access
6. CloudWatch Log Group for CodeBuild logs

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# VPC Configuration
resource "aws_vpc" "autograder_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "autograder-vpc"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.autograder_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "autograder-private-subnet"
  }
}

# VPC Endpoints
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.autograder_vpc.id
  service_name = "com.amazonaws.us-west-2.s3"

  tags = {
    Name = "s3-endpoint"
  }
}

resource "aws_vpc_endpoint" "codebuild" {
  vpc_id             = aws_vpc.autograder_vpc.id
  service_name       = "com.amazonaws.us-west-2.codebuild"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.private.id]
  security_group_ids = [aws_security_group.endpoint_sg.id]

  private_dns_enabled = true
}

# Security Group for VPC Endpoints
resource "aws_security_group" "endpoint_sg" {
  name        = "endpoint-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = aws_vpc.autograder_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.autograder_vpc.cidr_block]
  }
}

# S3 Bucket for Results
resource "aws_s3_bucket" "results" {
  bucket = "autograder-results-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket_versioning" "results" {
  bucket = aws_s3_bucket.results.id
  versioning_configuration {
    status = "Enabled"
  }
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "autograder" {
  name              = "/aws/codebuild/autograder"
  retention_in_days = 14
}

# IAM Role for CodeBuild
resource "aws_iam_role" "codebuild" {
  name = "autograder-codebuild-role"

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

resource "aws_iam_role_policy" "codebuild" {
  role = aws_iam_role.codebuild.name

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
          aws_s3_bucket.results.arn,
          "${aws_s3_bucket.results.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.autograder.arn}:*"
      }
    ]
  })
}

# CodeBuild Project
resource "aws_codebuild_project" "autograder" {
  name          = "autograder"
  description   = "Autograder for CS class"
  build_timeout = "30"
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                      = "aws/codebuild/standard:5.0"
    type                       = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/your-org/your-repo.git"
    git_clone_depth = 1
  }

  vpc_config {
    vpc_id             = aws_vpc.autograder_vpc.id
    subnets            = [aws_subnet.private.id]
    security_group_ids = [aws_security_group.codebuild_sg.id]
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.autograder.name
      status     = "ENABLED"
    }
  }
}

# Security Group for CodeBuild
resource "aws_security_group" "codebuild_sg" {
  name        = "codebuild-sg"
  description = "Security group for CodeBuild"
  vpc_id      = aws_vpc.autograder_vpc.id

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.autograder_vpc.cidr_block]
  }
}
</iac_template>

This Terraform configuration creates a secure environment for running student code submissions:

1. Creates a VPC with a private subnet (no internet gateway)
2. Sets up VPC endpoints for S3 and CodeBuild to allow internal AWS service communication
3. Creates an S3 bucket for storing grading results
4. Sets up a CodeBuild project that runs in the private VPC
5. Configures necessary IAM roles and policies
6. Creates security groups to control network access
7. Sets up CloudWatch logging for the CodeBuild project

The configuration ensures that student code runs in an isolated environment with no internet access, while still allowing access to necessary AWS services through VPC endpoints. Results are stored in S3, and logs are maintained in CloudWatch.

To use this configuration:
1. Replace the GitHub repository URL in the CodeBuild project with your actual repository
2. Deploy the infrastructure using Terraform
3. Set up your GitHub webhook or trigger mechanism
4. Place your grading scripts in the GitHub repository

The system will securely run and grade student submissions while maintaining isolation and logging.