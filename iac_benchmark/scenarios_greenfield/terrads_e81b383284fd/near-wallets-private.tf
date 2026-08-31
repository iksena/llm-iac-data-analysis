######## WalletsPrivate Table (name=near-wallets-private)

resource "aws_dynamodb_table" "near-wallets-private" {
  name         = "near-wallets-private"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "walletId"

  attribute {
    name = "walletId"
    type = "S"
  }

  attribute {
    name = "userId"
    type = "S"
  }

  global_secondary_index {
    name               = "UserIdIndex"
    hash_key           = "userId"
    range_key          = "walletId"
    projection_type    = "ALL"
  }

  tags = {
    Name        = "near-wallets-private"
    Environment = var.environment
  }

    lifecycle {
    prevent_destroy = true
    } 
}