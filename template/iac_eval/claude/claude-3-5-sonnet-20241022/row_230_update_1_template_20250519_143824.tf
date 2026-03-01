provider "aws" {
  region = "us-east-1"
}

# Create DynamoDB table with TTL
resource "aws_dynamodb_table" "ttl_table" {
  name           = "data-expiration-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "ItemId"
  range_key      = "CreatedAt"

  attribute {
    name = "ItemId"
    type = "S"
  }

  attribute {
    name = "CreatedAt"
    type = "N"
  }

  ttl {
    attribute_name = "ExpiryTime"
    enabled        = true
  }

  tags = {
    Name        = "dynamodb-ttl-table"
    Environment = "production"
  }
}

# Output the table name and TTL status
output "dynamodb_table_name" {
  value = aws_dynamodb_table.ttl_table.name
}

output "dynamodb_ttl_status" {
  value = aws_dynamodb_table.ttl_table.ttl[0].enabled
}