provider "aws" {
  region = "us-east-1"
}

# Create DynamoDB table with PITR enabled
resource "aws_dynamodb_table" "example_table" {
  name           = "example-table-with-pitr"
  billing_mode   = "PAY_PER_REQUEST"  # On-demand capacity mode
  hash_key       = "id"
  
  # Enable point-in-time recovery
  point_in_time_recovery {
    enabled = true
  }

  # Define attributes
  attribute {
    name = "id"
    type = "S"  # String type
  }

  # Add tags
  tags = {
    Environment = "Production"
    Purpose     = "Example table with PITR"
  }
}

# Output the table ARN
output "table_arn" {
  value = aws_dynamodb_table.example_table.arn
}

# Output the table name
output "table_name" {
  value = aws_dynamodb_table.example_table.name
}