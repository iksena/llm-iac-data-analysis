######## Files Table (name=near-storage)
resource "aws_dynamodb_table" "near-storage" {
  name           = "near-storage"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "pk"
  range_key      = "sk"
  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  attribute {
    name = "pk1"
    type = "S"
  }

  attribute {
    name = "sk1"
    type = "S"
  }

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }

  global_secondary_index {
    name               = "GSI1"
    hash_key           = "pk1"
    range_key          = "sk1"
    projection_type    = "ALL"
  }

  tags = {
    Name        = "near-storage"
    Environment = var.environment
  }

   lifecycle {
    prevent_destroy = true
    }  
}

######## SSM Parameters to be used 
resource "aws_ssm_parameter" "near-storage-ddb-arn" {
  name        = "/file-service/dynamodb/storage/arn"
  type        = "String"
  value       = aws_dynamodb_table.near-storage.arn
}

resource "aws_ssm_parameter" "near-storage-ddb-name" {
  name        = "/file-service/dynamodb/storage/name"
  type        = "String"
  value       = aws_dynamodb_table.near-storage.name
}

resource "aws_ssm_parameter" "near-storage-ddb-stream-arn" {
  name        = "/file-service/dynamodb/storage/streamArn"
  type        = "String"
  value       = aws_dynamodb_table.near-storage.stream_arn
}
