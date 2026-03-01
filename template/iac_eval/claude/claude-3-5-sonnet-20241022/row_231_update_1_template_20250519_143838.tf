provider "aws" {
  region = "us-east-1"
}

# Create DynamoDB table with encryption enabled
resource "aws_dynamodb_table" "encrypted_table" {
  name           = "encrypted-dynamodb-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  
  # Define primary key attribute
  attribute {
    name = "id"
    type = "S"
  }

  # Enable server-side encryption using AWS managed KMS key
  server_side_encryption {
    enabled = true
  }

  # Add tags for better resource management
  tags = {
    Environment = "Production"
    Purpose     = "Encrypted Data Storage"
  }
}