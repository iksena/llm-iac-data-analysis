provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "kendra_role" {
  name = "KendraServiceRole"
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

resource "aws_iam_role_policy" "kendra_policy" {
  name = "KendraServicePolicy"
  role = aws_iam_role.kendra_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_kendra_index" "example" {
  name        = "example-kendra-index"
  role_arn    = aws_iam_role.kendra_role.arn
  description = "A basic Kendra index"

  capacity_units {
    query_capacity_units = 1
    storage_capacity_units = 1
  }

  lifecycle {
    ignore_changes = [document_metadata_configuration_updates]
  }
}