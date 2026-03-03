I'll help you create a Terraform configuration that sets up an AWS CodeBuild project with the specified requirements, including VPC, Security Group, and S3 bucket for artifacts. Here's a description of what we'll create:

1. AWS S3 bucket for storing CodeBuild outputs
2. VPC with specified CIDR block (10.0.0.0/16)
3. Subnet within the VPC (10.0.0.0/24)
4. Security Group with no ingress/egress rules
5. CodeBuild project connected to GitHub source, using the VPC configuration and S3 bucket for artifacts

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-east-1"
}

# S3 bucket for build artifacts
resource "aws_s3_bucket" "codebuild_artifacts" {
  bucket = "codebuild-artifacts-bucket-${random_string.bucket_suffix.result}"
}

# Random string for unique bucket name
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "codebuild-vpc"
  }
}

# Subnet
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "codebuild-subnet"
  }
}

# Security Group
resource "aws_security_group" "codebuild_sg" {
  name        = "codebuild-sg"
  description = "Security group for CodeBuild project"
  vpc_id      = aws_vpc.main.id

  # No ingress rules
  # No egress rules

  tags = {
    Name = "codebuild-sg"
  }
}

# IAM role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-role"

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

# IAM policy for CodeBuild
resource "aws_iam_role_policy" "codebuild_policy" {
  role = aws_iam_role.codebuild_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.codebuild_artifacts.arn}",
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
          "logs:PutLogEvents",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ]
      }
    ]
  })
}

# CodeBuild Project
resource "aws_codebuild_project" "project" {
  name          = "student-code-build"
  description   = "Student code build project"
  service_role  = aws_iam_role.codebuild_role.arn
  build_timeout = "30"

  artifacts {
    type     = "S3"
    location = aws_s3_bucket.codebuild_artifacts.bucket
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

  vpc_config {
    vpc_id             = aws_vpc.main.id
    subnets           = [aws_subnet.main.id]
    security_group_ids = [aws_security_group.codebuild_sg.id]
  }

  tags = {
    Environment = "Test"
  }
}
</iac_template>

This Terraform configuration creates all the required resources with the specified configurations. A few important notes:

1. The S3 bucket name includes a random suffix to ensure uniqueness
2. The security group has no ingress or egress rules as requested
3. Necessary IAM roles and policies are created for CodeBuild to function
4. The VPC and subnet are created with the specified CIDR blocks
5. The CodeBuild project is configured with all the required specifications

Make sure to replace "github.com/source-location" with your actual GitHub repository URL before deploying. Also, note that since the security group blocks all traffic, you'll need to set up appropriate networking (like VPC endpoints) if you need the CodeBuild project to access AWS services or external resources.