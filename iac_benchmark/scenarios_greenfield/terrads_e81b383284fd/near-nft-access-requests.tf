######## NFTShares Table (name=near-nft-access-requests)

resource "aws_dynamodb_table" "near-nft-access-requests" {
  name         = "near-nft-access-requests"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "requestId"

  attribute {
    name = "requestId"
    type = "S"
  }

  attribute {
    name = "nftId"
    type = "S"
  }

  attribute {
    name = "ownerId"
    type = "S"
  }

  attribute {
    name = "requesterId"
    type = "S"
  }

  global_secondary_index {
    name               = "nftId-Index"
    hash_key           = "nftId"
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "ownerId-Index"
    hash_key           = "ownerId"
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "requesterId-Index"
    hash_key           = "requesterId"
    projection_type    = "ALL"
  }

  
  tags = {
    Name        = "near-nft-access-requests"
    Environment = var.environment
  }
  lifecycle {
    prevent_destroy = true
    } 

}
