######## NFTOffers Table (name=near-nft-offers)

resource "aws_dynamodb_table" "near-nft-offers" {
  name         = "near-nft-offers"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "offerId"

  attribute {
    name = "offerId"
    type = "S"
  }

  attribute {
    name = "nftId"
    type = "S"
  }

  global_secondary_index {
    name               = "nftId-Index"
    hash_key           = "nftId"
    projection_type    = "ALL"
  }
  
  tags = {
    Name        = "near-nft-offers"
    Environment = var.environment
  }

   lifecycle {
    prevent_destroy = true
    }  
}