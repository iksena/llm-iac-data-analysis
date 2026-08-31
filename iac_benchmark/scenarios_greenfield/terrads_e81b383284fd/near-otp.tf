######## OTP Table (name=near-otp)


resource "aws_dynamodb_table" "near-otp" {
  name         = "near-otp"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"
  range_key    = "ttl"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "ttl"
    type = "N"
  }

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }

  tags = {
    Name        = "near-otp"
    Environment = var.environment
  }

  lifecycle {
    prevent_destroy = true
    } 
}