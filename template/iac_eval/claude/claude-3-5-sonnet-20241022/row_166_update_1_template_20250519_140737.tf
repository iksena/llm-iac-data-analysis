provider "aws" {
  region = "us-east-1"
}

# Create DynamoDB Table
resource "aws_dynamodb_table" "example_table" {
  name           = "example-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "user_id"
  
  attribute {
    name = "user_id"
    type = "S"
  }
}

# Add item to DynamoDB Table
resource "aws_dynamodb_table_item" "example_item" {
  table_name = aws_dynamodb_table.example_table.name
  hash_key   = aws_dynamodb_table.example_table.hash_key

  item = jsonencode({
    user_id = {
      S = "001"
    }
    first_name = {
      S = "John"
    }
    last_name = {
      S = "Doe"
    }
    email = {
      S = "john.doe@example.com"
    }
    age = {
      N = "30"
    }
  })
}