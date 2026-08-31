######## NFTCollections Table (name=near-nft-collections)
resource "aws_dynamodb_table" "near-nft-collections" {
  name         = "near-nft-collections"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "collectionId"

  attribute {
    name = "collectionId"
    type = "S"
  }

  attribute {
    name = "ownerId"
    type = "S"
  }

  global_secondary_index {
    name               = "OwnerIdIndex"
    hash_key           = "ownerId"
    projection_type    = "ALL"
  }

  tags = {
    Name        = "near-nft-collections"
    Environment = var.environment
  }

   lifecycle {
    prevent_destroy = true
    } 

}