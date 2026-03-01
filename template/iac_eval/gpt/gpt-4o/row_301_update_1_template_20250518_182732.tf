provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "codebuild_output" {
  bucket = "codebuild-output-bucket-example"
  acl    = "private"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "no_internet" {
  name        = "no-internet-access"
  description = "Security group with no ingress or egress"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = []
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = []
  }
}

resource "aws_codebuild_project" "student_project" {
  name          = "student-codebuild-project"
  description   = "CodeBuild project for student code builds"
  service_role  = aws_iam_role.codebuild_service_role.arn

  artifacts {
    type     = "S3"
    location = aws_s3_bucket.codebuild_output.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = false
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/source-location"
    git_clone_depth = 1
  }

  vpc_config {
    vpc_id            = aws_vpc.main.id
    subnets           = [aws_subnet.main.id]
    security_group_ids = [aws_security_group.no_internet.id]
  }
}

resource "aws_iam_role" "codebuild_service_role" {
  name = "codebuild-service-role"

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

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "codebuild-policy"
  role = aws_iam_role.codebuild_service_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.codebuild_output.arn,
          "${aws_s3_bucket.codebuild_output.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}