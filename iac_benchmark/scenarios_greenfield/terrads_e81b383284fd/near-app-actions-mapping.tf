######## AppActionsMapping Table (name=near-app-actions-mapping)
resource "aws_dynamodb_table" "near-app-actions-mapping" {
  name         = "near-app-actions-mapping"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "appId"

  attribute {
    name = "appId"
    type = "S"
  }

  tags = {
    Name        = "near-app-actions-mapping"
    Environment = var.environment
  }
    lifecycle {
    prevent_destroy = true
    }  
}