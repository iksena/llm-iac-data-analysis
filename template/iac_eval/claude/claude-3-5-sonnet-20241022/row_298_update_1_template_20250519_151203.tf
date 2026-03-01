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