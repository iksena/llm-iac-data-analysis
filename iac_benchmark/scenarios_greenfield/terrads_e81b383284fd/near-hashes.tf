######## Hashes Table (name=near-hashes)
resource "aws_dynamodb_table" "near-hashes" {
  name           = "near-hashes"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "hk"
  range_key       = "sk"
  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "hk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  attribute {
    name = "hk1"
    type = "S"
  }

  attribute {
    name = "sk1"
    type = "S"
  }


  global_secondary_index {
    name               = "hk1-sk1-Index"
    hash_key           = "hk1"
    range_key          = "sk1"
    projection_type    = "ALL"
  }

  tags = {
    Name        = "near-hashes"
    Environment = var.environment
  }

   lifecycle {
    prevent_destroy = true
    }  
}

######## SSM Parameters to be used
resource "aws_ssm_parameter" "near-hashes-ddb-arn" {
  name        = "/hashes-service/dynamodb/hashes/arn"
  type        = "String"
  value       = aws_dynamodb_table.near-hashes.arn
}

resource "aws_ssm_parameter" "near-hashes-ddb-name" {
  name        = "/hashes-service/dynamodb/hashes/name"
  type        = "String"
  value       = aws_dynamodb_table.near-hashes.name
}

resource "aws_ssm_parameter" "near-hashes-ddb-stream-arn" {
  name        = "/hashes-service/dynamodb/hashes/streamArn"
  type        = "String"
  value       = aws_dynamodb_table.near-hashes.stream_arn
}
