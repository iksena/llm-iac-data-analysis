provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "kendra_role" {
  name = "KendraIndexRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "kendra.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "kendra_policy" {
  name        = "KendraIndexPolicy"
  description = "Policy for Kendra index access"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "kendra_policy_attachment" {
  role       = aws_iam_role.kendra_role.name
  policy_arn = aws_iam_policy.kendra_policy.arn
}

resource "aws_kendra_index" "example" {
  name        = "example-kendra-index"
  role_arn    = aws_iam_role.kendra_role.arn
  edition     = "DEVELOPER_EDITION"

  user_token_configurations {
    json_token_type_configuration {
      user_name_attribute_field = "username"
      group_attribute_field     = "groups"
    }
  }
}