provider "aws" {
  region = "us-east-1"
}

# Create DynamoDB table
resource "aws_dynamodb_table" "example_table" {
  name           = "example-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  stream_enabled = true

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Environment = "production"
  }
}

# Enable Contributor Insights for the DynamoDB table
resource "aws_dynamodb_contributor_insights" "example" {
  table_name = aws_dynamodb_table.example_table.name

  # Custom settings for Contributor Insights
  contributor_insights_status = "ENABLED"
}

# Create IAM role for Contributor Insights
resource "aws_iam_role" "contributor_insights_role" {
  name = "dynamodb-contributor-insights-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "contributorinsights.amazonaws.com"
        }
      }
    ]
  })
}

# Create IAM policy for Contributor Insights
resource "aws_iam_role_policy" "contributor_insights_policy" {
  name = "dynamodb-contributor-insights-policy"
  role = aws_iam_role.contributor_insights_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "dynamodb:DescribeTable",
          "dynamodb:ListTables"
        ]
        Resource = "*"
      }
    ]
  })
}

# Output the table name and Contributor Insights status
output "table_name" {
  value = aws_dynamodb_table.example_table.name
}

output "contributor_insights_status" {
  value = aws_dynamodb_contributor_insights.example.contributor_insights_status
}