provider "aws" {
  region = "us-east-1"
}

resource "aws_dynamodb_table" "example" {
  name           = "example-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  server_side_encryption {
    enabled     = true
    sse_type    = "AES256"
  }

  tags = {
    Environment = "Production"
    Name        = "ExampleDynamoDBTable"
  }
}