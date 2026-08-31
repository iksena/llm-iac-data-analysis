######## NFTs Table (name=near-nfts)
resource "aws_dynamodb_table" "near-nfts" {
  name         = "near-nfts"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "nftId"

  attribute {
    name = "nftId"
    type = "S"
  }

  attribute {
    name = "ownerWalletId"
    type = "S"
  }

  attribute {
    name = "transactionId"
    type = "S"
  }

  global_secondary_index {
    name               = "ownerWalletId-Index"
    hash_key           = "ownerWalletId"
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "transactionId-Index"
    hash_key           = "transactionId"
    projection_type    = "ALL"
  }

  tags = {
    Name        = "near-nfts"
    Environment = var.environment
  }

   lifecycle {
    prevent_destroy = true
    }  
}