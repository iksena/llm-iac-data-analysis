I'll help create a Terraform configuration for an autograder system that securely runs student code submissions. Here's what the infrastructure will include:

1. A VPC with a private subnet (no internet access)
2. Security groups to control network access
3. S3 bucket to store grading results
4. CodeBuild project running in the private subnet to execute student code
5. IAM roles and policies for CodeBuild
6. VPC Endpoints to allow CodeBuild to access S3 and GitHub without internet access

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# Variables
variable "project_name" {
  description = "Name of the autograder project"
  default     = "cs-autograder"
}

# VPC Configuration
resource "aws_vpc" "autograder_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.autograder_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "${var.project_name}-private-subnet"
  }
}

# Security Group
resource "aws_security_group" "codebuild_sg" {
  name        = "${var.project_name}-codebuild-sg"
  description = "Security group for CodeBuild"
  vpc_id      = aws_vpc.autograder_vpc.id

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# S3 Bucket for results
resource "aws_s3_bucket" "results_bucket" {
  bucket = "${var.project_name}-results"
}

resource "aws_s3_bucket_versioning" "results_versioning" {
  bucket = aws_s3_bucket.results_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# VPC Endpoints
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.autograder_vpc.id
  service_name = "com.amazonaws.us-west-2.s3"
}

resource "aws_vpc_endpoint" "codebuild" {
  vpc_id             = aws_vpc.autograder_vpc.id
  service_name       = "com.amazonaws.us-west-2.codebuild"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.private_subnet.id]
  security_group_ids = [aws_security_group.codebuild_sg.id]
}

# IAM Role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "${var.project_name}-codebuild-role"

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

# IAM Policy for CodeBuild
resource "aws_iam_role_policy" "codebuild_policy" {
  name = "${var.project_name}-codebuild-policy"
  role = aws_iam_role.codebuild_role.id

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
          aws_s3_bucket.results_bucket.arn,
          "${aws_s3_bucket.results_bucket.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = ["*"]
      }
    ]
  })
}

# CodeBuild Project
resource "aws_codebuild_project" "autograder" {
  name          = var.project_name
  description   = "Autograder for CS class"
  service_role  = aws_iam_role.codebuild_role.arn
  build_timeout = "30"

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
    location        = "https://github.com/your-repo/autograder.git"
    git_clone_depth = 1
  }

  vpc_config {
    vpc_id             = aws_vpc.autograder_vpc.id
    subnets           = [aws_subnet.private_subnet.id]
    security_group_ids = [aws_security_group.codebuild_sg.id]
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }
}
</iac_template>

This Terraform configuration creates a secure environment for running student code submissions:

1. Creates a VPC with a private subnet that has no internet access
2. Sets up necessary VPC endpoints for S3 and CodeBuild to work without internet access
3. Creates an S3 bucket to store grading results
4. Establishes a CodeBuild project that runs in the private subnet
5. Sets up appropriate IAM roles and policies
6. Configures security groups to restrict network access

To use this configuration:
1. Replace "your-repo/autograder.git" with your actual GitHub repository
2. Ensure you have AWS credentials configured
3. The CodeBuild project will run in a private subnet without internet access
4. Results will be stored in the S3 bucket
5. Students' code will be isolated and unable to access the internet

The configuration includes all necessary components for a secure autograding system while maintaining isolation of student code executions.