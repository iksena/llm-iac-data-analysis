provider "aws" {
  region = "us-east-1"
}

# Create DynamoDB table with encryption at rest
resource "aws_dynamodb_table" "encrypted_table" {
  name           = "encrypted-dynamodb-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "ID"
  
  # Enable server-side encryption using AWS managed KMS key
  server_side_encryption {
    enabled = true
  }

  # Enable point-in-time recovery for additional data protection
  point_in_time_recovery {
    enabled = true
  }

  # Define primary key
  attribute {
    name = "ID"
    type = "S"
  }

  # Add tags for better resource management
  tags = {
    Environment = "Production"
    Purpose     = "Secure Data Storage"
  }
}