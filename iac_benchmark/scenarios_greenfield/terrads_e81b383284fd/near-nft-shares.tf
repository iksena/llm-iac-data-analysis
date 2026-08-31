######## NFTShares Table (name=near-nft-shares)

resource "aws_dynamodb_table" "near-nft-shares" {
  name         = "near-nft-shares"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "shareId"

  attribute {
    name = "shareId"
    type = "S"
  }

  attribute {
    name = "nftId"
    type = "S"
  }

  attribute {
    name = "ownerWalletId"
    type = "S"
  }

  attribute {
    name = "recipientWalletId"
    type = "S"
  }

  global_secondary_index {
    name               = "nftId-Index"
    hash_key           = "nftId"
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "ownerWalletId-Index"
    hash_key           = "ownerWalletId"
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "recipientWalletId-Index"
    hash_key           = "recipientWalletId"
    projection_type    = "ALL"
  }

  
  tags = {
    Name        = "near-nft-shares"
    Environment = var.environment
  }
  lifecycle {
    prevent_destroy = true
    } 

}
