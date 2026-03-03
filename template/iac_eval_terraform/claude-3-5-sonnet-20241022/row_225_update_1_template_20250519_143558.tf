provider "aws" {
  region = "us-east-1"
}

# Create DynamoDB table
resource "aws_dynamodb_table" "demo_table" {
  name           = "demo-dynamodb-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "demo-dynamodb-table"
    Environment = "production"
    Managed_by  = "terraform"
  }
}