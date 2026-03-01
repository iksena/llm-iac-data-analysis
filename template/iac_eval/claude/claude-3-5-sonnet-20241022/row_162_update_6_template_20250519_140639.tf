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

# Output the table name and ARN
output "table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.example_table.name
}

output "table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.example_table.arn
}