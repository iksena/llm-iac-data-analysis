######## Apps Table (name=near-hidden)
resource "aws_dynamodb_table" "near-hidden" {
  name         = "near-hidden"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "near-hidden"
    Environment = var.environment
  }

   lifecycle {
    prevent_destroy = true
    }  
}