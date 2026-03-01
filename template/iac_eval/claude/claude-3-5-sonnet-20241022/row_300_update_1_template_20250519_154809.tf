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