provider "aws" {
  region = "us-west-2"
}

resource "aws_dynamodb_table" "example" {
  name           = "example-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = "example-table"
  }
}

resource "aws_dynamodb_contributor_insights" "example" {
  table_name = aws_dynamodb_table.example.name
  enabled    = true
}