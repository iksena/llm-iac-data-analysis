provider "aws" {
  region = "us-east-1"
}

# Create DynamoDB table
resource "aws_dynamodb_table" "example_table" {
  name           = "example-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "id"
    type = "S"
  }

  contributor_insights {
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}

# Output the table name
output "table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.example_table.name
}

output "contributor_insights_status" {
  description = "Status of Contributor Insights"
  value       = aws_dynamodb_table.example_table.contributor_insights[0].enabled
}