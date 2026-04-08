resource "aws_dynamodb_table" "table_one" {
  name           = var.dynamodb_table_one_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "user_id"
  range_key      = "timestamp"

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }
}

resource "aws_dynamodb_table" "table_two" {
  name           = var.dynamodb_table_two_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "user_id"
  range_key      = "offer_id"


  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "offer_id"
    type = "S"
  }
}
