######## Apps Table (name=near-apps)
resource "aws_dynamodb_table" "near-apps" {
  name         = "near-apps"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "appId"

  attribute {
    name = "appId"
    type = "S"
  }

  attribute {
    name = "categoryId"
    type = "S"
  }

    global_secondary_index {
    name               = "categoryId-Index"
    hash_key           = "categoryId"
    projection_type    = "ALL"
  }

  tags = {
    Name        = "near-apps"
    Environment = var.environment
  }
    lifecycle {
    prevent_destroy = true
    }  
}