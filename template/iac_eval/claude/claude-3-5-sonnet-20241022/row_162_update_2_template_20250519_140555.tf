provider "aws" {
  region = "us-east-1"
}

# Create DynamoDB table
resource "aws_dynamodb_table" "example_table" {
  name           = "example-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Environment = "production"
  }
}

# Enable Contributor Insights for the DynamoDB table
resource "aws_dynamodb_table_contributor_insights" "example" {
  table_name = aws_dynamodb_table.example_table.name
  enabled    = true
}

# Output the table name and Contributor Insights status
output "table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.example_table.name
}

output "contributor_insights_enabled" {
  description = "Status of Contributor Insights"
  value       = aws_dynamodb_table_contributor_insights.example.enabled
}