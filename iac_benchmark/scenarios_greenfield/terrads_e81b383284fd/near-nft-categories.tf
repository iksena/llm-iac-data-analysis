######## NFTCategories Table (name=near-nft-categories)
resource "aws_dynamodb_table" "near-nft-categories" {
  name         = "near-nft-categories"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "categoryId"

  attribute {
    name = "categoryId"
    type = "S"
  }

  tags = {
    Name        = "near-nft-categories"
    Environment = var.environment
  }

   lifecycle {
    prevent_destroy = true
    } 

}