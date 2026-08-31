######## NFTShares Table (name=near-folders)

resource "aws_dynamodb_table" "near-folders" {
  name         = "near-folders"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "walletId"
  range_key    = "id"

  attribute {
    name = "walletId"
    type = "S"
  }

  attribute {
    name = "id"
    type = "S"
  }

  
  tags = {
    Name        = "near-folders"
    Environment = var.environment
  }
  lifecycle {
    prevent_destroy = true
    } 

}
