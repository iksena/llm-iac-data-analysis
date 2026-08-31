resource "aws_dynamodb_table" "dev_state_lock" {
  provider     = aws.eu_central_1
  name         = "utkusarioglu-com-dev-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  tags         = local.default_tags
  attribute {
    name = "LockID"
    type = "S"
  }
}
