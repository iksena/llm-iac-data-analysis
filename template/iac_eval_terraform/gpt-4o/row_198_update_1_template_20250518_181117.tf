provider "aws" {
  region = "us-east-1"
}

resource "aws_dynamodb_table" "example_table" {
  name           = "ExampleTableName"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_dynamodb_contributor_insights" "example_table_insights" {
  table_name = aws_dynamodb_table.example_table.name
  enabled    = true
}