######## Contacts Table (name=near-contacts)
resource "aws_dynamodb_table" "near-contacts" {
  name         = "near-contacts"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "contactId"

  attribute {
    name = "contactId"
    type = "S"
  }

  attribute {
    name = "userId"
    type = "S"
  }

  global_secondary_index {
    name               = "userId-contactId-index"
    hash_key           = "userId"
    range_key          = "contactId"
    projection_type    = "ALL"
  }

  tags = {
    Name        = "near-contacts"
    Environment = var.environment
  }
  lifecycle {
    prevent_destroy = true
    }  
}
