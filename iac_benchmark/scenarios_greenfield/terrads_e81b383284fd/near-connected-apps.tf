######## ConnectedApps Table (name=near-connected-apps)
resource "aws_dynamodb_table" "near-connected-apps" {
  name         = "near-connected-apps"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "connectionId"

  attribute {
    name = "connectionId"
    type = "S"
  }

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "appId"
    type = "S"
  }

  global_secondary_index {
    name               = "userId-Index"
    hash_key           = "userId"
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "appId-Index"
    hash_key           = "appId"
    projection_type    = "ALL"
  }

  tags = {
    Name        = "near-connected-apps"
    Environment = var.environment
  }
 lifecycle {
    prevent_destroy = true
    }
}

