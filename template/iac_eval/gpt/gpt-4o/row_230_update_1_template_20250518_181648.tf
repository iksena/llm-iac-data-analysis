provider "aws" {
  region = "us-east-1"
}

resource "aws_dynamodb_table" "example" {
  name           = "example-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "expiration_time"
    type = "N"
  }

  ttl {
    attribute_name = "expiration_time"
    enabled        = true
  }

  tags = {
    Name        = "example-table"
    Environment = "dev"
  }
}

resource "aws_iam_role" "dynamodb_ttl_role" {
  name = "dynamodb-ttl-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "dynamodb.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "dynamodb_ttl_policy" {
  name        = "dynamodb-ttl-policy"
  description = "Policy to allow DynamoDB to manage TTL"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:UpdateTimeToLive"
        ]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.example.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_ttl_policy" {
  role       = aws_iam_role.dynamodb_ttl_role.name
  policy_arn = aws_iam_policy.dynamodb_ttl_policy.arn
}