I'll help create a Terraform configuration for an autograder system using AWS CodeBuild within a VPC that restricts internet access. Here's what the infrastructure will include:

1. A VPC with private subnets (no internet access)
2. VPC Endpoints for CodeBuild and S3 (to allow internal AWS service communication)
3. CodeBuild project configuration with GitHub source
4. IAM roles and policies for CodeBuild
5. S3 bucket for storing grading results
6. Security groups to restrict network access

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-east-1"
}

# Variables
variable "github_repo_url" {
  description = "GitHub repository URL"
  default     = "https://github.com/example/student-submissions"
}

variable "github_token" {
  description = "GitHub personal access token"
  default     = "dummy-token"
  sensitive   = true
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
  availability_zone = "us-east-1a"

  tags = {
    Name = "autograder-private-subnet"
  }
}

# VPC Endpoints
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.autograder_vpc.id
  service_name = "com.amazonaws.us-east-1.s3"
  
  tags = {
    Name = "s3-endpoint"
  }
}

resource "aws_vpc_endpoint" "codebuild" {
  vpc_id             = aws_vpc.autograder_vpc.id
  service_name       = "com.amazonaws.us-east-1.codebuild"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.private.id]
  security_group_ids = [aws_security_group.codebuild_endpoint.id]

  private_dns_enabled = true

  tags = {
    Name = "codebuild-endpoint"
  }
}

# Security Group for VPC Endpoint
resource "aws_security_group" "codebuild_endpoint" {
  name        = "codebuild-endpoint-sg"
  description = "Security group for CodeBuild VPC endpoint"
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
  bucket = "autograder-results-${random_string.bucket_suffix.result}"
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  lower   = true
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
        Resource = [
          "${aws_s3_bucket.results.arn}/*",
          aws_s3_bucket.results.arn
        ]
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
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
    location        = var.github_repo_url
    git_clone_depth = 1
    
    auth {
      type     = "OAUTH"
      resource = var.github_token
    }
  }

  vpc_config {
    vpc_id             = aws_vpc.autograder_vpc.id
    subnets           = [aws_subnet.private.id]
    security_group_ids = [aws_security_group.codebuild.id]
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }
}

# Security Group for CodeBuild
resource "aws_security_group" "codebuild" {
  name        = "autograder-codebuild-sg"
  description = "Security group for CodeBuild project"
  vpc_id      = aws_vpc.autograder_vpc.id

  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.codebuild_endpoint.id]
  }
}
</iac_template>

This configuration creates a secure environment for running student code with the following features:

1. A VPC with a private subnet that has no internet access
2. VPC endpoints for S3 and CodeBuild to allow internal AWS service communication
3. An S3 bucket for storing grading results
4. A CodeBuild project that:
   - Pulls code from GitHub
   - Runs in the private VPC
   - Has no internet access
   - Can only communicate with necessary AWS services through VPC endpoints
   - Stores results in the S3 bucket
5. Appropriate IAM roles and security groups to enforce least privilege access

To use this configuration:

1. Replace the `github_repo_url` variable default value with your actual GitHub repository URL
2. Provide a valid GitHub token for authentication
3. Customize the CodeBuild environment and build specifications as needed
4. Add any additional VPC endpoints required for your specific grading needs

The configuration ensures that student code cannot access the internet while being graded, as it runs in a private subnet with no internet gateway or NAT gateway, and security groups only allow access to necessary AWS services through VPC endpoints.