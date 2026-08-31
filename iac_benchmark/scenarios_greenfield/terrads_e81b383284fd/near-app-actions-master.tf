######## AppActionsMaster Table (name=near-app-actions-master)
resource "aws_dynamodb_table" "near-app-actions-master" {
  name         = "near-app-actions-master"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "actionId"

  attribute {
    name = "actionId"
    type = "S"
  }

  tags = {
    Name        = "near-app-actions-master"
    Environment = var.environment
  }

    lifecycle {
    prevent_destroy = true
    }
}