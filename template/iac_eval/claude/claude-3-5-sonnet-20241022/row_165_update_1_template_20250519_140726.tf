provider "aws" {
  region = "us-east-1"
}

# Create DynamoDB Table
resource "aws_dynamodb_table" "demo_table" {
  name           = "demo-dynamodb-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Environment = "production"
    Purpose     = "demo"
  }

  # Enable server-side encryption by default using AWS managed key
  server_side_encryption {
    enabled = true
  }
}