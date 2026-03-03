provider "aws" {
  region = "us-east-1"
}

# Create IAM role for Kendra
resource "aws_iam_role" "kendra_role" {
  name = "kendra_service_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "kendra.amazonaws.com"
        }
      }
    ]
  })
}

# Attach required policies to the IAM role
resource "aws_iam_role_policy_attachment" "kendra_policy" {
  role       = aws_iam_role.kendra_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSKendraServiceRole"
}

# Create Kendra Index
resource "aws_kendra_index" "example" {
  name        = "example-kendra-index"
  description = "Example Kendra Index with user group resolution"
  role_arn    = aws_iam_role.kendra_role.arn

  # Configure user group resolution
  user_group_resolution_configuration {
    user_group_resolution_mode = "AWS_SSO"
  }

  # Required server side encryption configuration
  server_side_encryption_configuration {
    kms_key_id = "aws/kendra"
  }

  # Required edition
  edition = "DEVELOPER_EDITION"

  tags = {
    Environment = "production"
    Purpose     = "search"
  }
}

# Output the Index ID
output "kendra_index_id" {
  value = aws_kendra_index.example.id
}