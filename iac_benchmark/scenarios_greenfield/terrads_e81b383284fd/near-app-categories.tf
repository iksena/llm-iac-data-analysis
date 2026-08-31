######## AppCategories Table (name=near-app-categories)
resource "aws_dynamodb_table" "near-app-categories" {
  name         = "near-app-categories"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "categoryId"

  attribute {
    name = "categoryId"
    type = "S"
  }

  tags = {
    Name        = "near-app-categories"
    Environment = var.environment
  }
   lifecycle {
    prevent_destroy = true
    } 
}