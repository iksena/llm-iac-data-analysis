provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "autograder_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "autograder_subnet" {
  vpc_id            = aws_vpc.autograder_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = false
}

resource "aws_security_group" "autograder_sg" {
  vpc_id = aws_vpc.autograder_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
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
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
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
  }
  artifacts {
    type = "NO_ARTIFACTS"
  }
  vpc_config {
    vpc_id            = aws_vpc.autograder_vpc.id
    subnets           = [aws_subnet.autograder_subnet.id]
    security_group_ids = [aws_security_group.autograder_sg.id]
  }
}