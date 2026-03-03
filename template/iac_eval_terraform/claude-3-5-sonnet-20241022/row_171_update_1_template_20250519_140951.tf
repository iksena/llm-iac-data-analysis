provider "aws" {
  region = "us-east-1"
}

# Create DynamoDB table with on-demand capacity
resource "aws_dynamodb_table" "users_table" {
  name           = "users-table"
  billing_mode   = "PAY_PER_REQUEST"  # This enables on-demand capacity mode
  hash_key       = "user_id"
  range_key      = "timestamp"

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Environment = "Production"
    Project     = "UserManagement"
    Terraform   = "true"
  }
}