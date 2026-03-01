provider "aws" {
  region = "us-east-1"
}

# Create DynamoDB table
resource "aws_dynamodb_table" "example_table" {
  name           = "ExampleTableName"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

# Enable contributor insights on the table
resource "aws_dynamodb_contributor_insights" "example" {
  table_name = aws_dynamodb_table.example_table.name
}