######## Apps Table (name=near-fiat-tokens)
resource "aws_dynamodb_table" "near-fiat-tokens" {
  name         = "near-fiat-tokens"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "symbol"

  attribute {
    name = "symbol"
    type = "S"
  }

  tags = {
    Name        = "near-fiat-tokens"
    Environment = var.environment
  }
    lifecycle {
    prevent_destroy = true
    }  
}