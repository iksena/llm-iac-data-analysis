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
resource "aws_iam_role_policy" "kendra_policy" {
  name = "kendra_service_policy"
  role = aws_iam_role.kendra_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "cloudwatch:namespace" = "AWS/Kendra"
          }
        }
      },
      {
        Effect = "Allow"
        Action = [
          "logs:DescribeLogGroups",
          "logs:CreateLogGroup"
        ]
        Resource = "arn:aws:logs:*:*:log-group:/aws/kendra/*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:DescribeLogStreams",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:log-group:/aws/kendra/*:log-stream:*"
      }
    ]
  })
}

# Create Kendra Index
resource "aws_kendra_index" "example" {
  name        = "example-kendra-index"
  description = "Example Kendra Index with default configuration"
  role_arn    = aws_iam_role.kendra_role.arn

  document_metadata_configuration_updates {
    name            = "_created_at"
    type            = "DATE_VALUE"
    relevance {
      freshness = true
    }
  }

  document_metadata_configuration_updates {
    name            = "_last_updated_at"
    type            = "DATE_VALUE"
    relevance {
      freshness = true
    }
  }

  document_metadata_configuration_updates {
    name            = "_source_uri"
    type            = "STRING_VALUE"
    relevance {
      importance = 1
    }
  }

  tags = {
    Environment = "production"
  }
}

# Output the Index ID
output "kendra_index_id" {
  value = aws_kendra_index.example.id
}