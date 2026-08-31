######## Apps Table (name=near-wallets-blockchain)
resource "aws_dynamodb_table" "near-wallets-blockchain" {
  name         = "near-wallets-blockchain"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "wallet_id"

  attribute {
    name = "wallet_id"
    type = "S"
  }


  tags = {
    Name        = "near-wallets-blockchain"
    Environment = var.environment
  }
  
    lifecycle {
    prevent_destroy = true
    }  
}
