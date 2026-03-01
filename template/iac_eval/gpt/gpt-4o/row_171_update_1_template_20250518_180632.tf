provider "aws" {
  region = "us-west-2"
}

resource "aws_dynamodb_table" "example" {
  name           = "example-table"
  billing_mode   = "PAY_PER_REQUEST"  # This sets the table to on-demand capacity mode
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Environment = "Production"
    Name        = "ExampleTable"
  }
}