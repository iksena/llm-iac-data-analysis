provider "aws" {
  region = "us-east-1"
}

# Create DynamoDB table
resource "aws_dynamodb_table" "basic_dynamodb_table" {
  name           = "basic-dynamodb-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "Id"

  # Enable point-in-time recovery
  point_in_time_recovery {
    enabled = true
  }

  # Define primary key
  attribute {
    name = "Id"
    type = "S"
  }

  # Add tags
  tags = {
    Name        = "basic-dynamodb-table"
    Environment = "production"
    Managed_by  = "terraform"
  }
}