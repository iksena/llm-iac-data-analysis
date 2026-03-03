provider "aws" {
  region = "us-east-1"
}

variable "kendra_index_name" {
  description = "The name of the Kendra index"
  type        = string
  default     = "example-kendra-index"
}

resource "aws_iam_role" "kendra_index_role" {
  name = "kendra-index-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "kendra.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_kendra_index" "this" {
  name    = var.kendra_index_name
  edition = "DEVELOPER"

  description = "Example Kendra index with user group resolution configuration"

  role_arn = aws_iam_role.kendra_index_role.arn

  user_group_resolution_configuration {
    user_group_resolution_mode = "AWS_SSO"
  }
}