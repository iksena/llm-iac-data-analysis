######## Users Table (name=near-users)
resource "aws_dynamodb_table" "near-users" {
  name         = "near-users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "phone"
    type = "S"
  }

  attribute {
    name = "email"
    type = "S"
  }

  global_secondary_index {
    name               = "PhoneIndex"
    hash_key           = "phone"
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "EmailIndex"
    hash_key           = "email"
    projection_type    = "ALL"
  }

  tags = {
    Name        = "near-users"
    Environment = var.environment
  }

  lifecycle {
    prevent_destroy = true
    }   
}