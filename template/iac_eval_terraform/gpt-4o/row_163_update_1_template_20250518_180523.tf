provider "aws" {
  region = "us-east-1"
  alias  = "useast1"
}

provider "aws" {
  region = "us-west-1"
  alias  = "uswest1"
}

provider "aws" {
  region = "us-west-2"
  alias  = "uswest2"
}

resource "aws_dynamodb_table" "example_useast1" {
  provider = aws.useast1
  name     = "example-table"
  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "example_uswest1" {
  provider = aws.uswest1
  name     = "example-table"
  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "example_uswest2" {
  provider = aws.uswest2
  name     = "example-table"
  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }

  billing_mode = "PAY_PER_REQUEST"
}