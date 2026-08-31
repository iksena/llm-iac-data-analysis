######## Files Table (name=near-files)
resource "aws_dynamodb_table" "near-files" {
  name           = "near-files"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "walletId"
  range_key      = "fileId"
  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "walletId"
    type = "S"
  }

  attribute {
    name = "fileId"
    type = "S"
  }

  attribute {
    name = "ownerId"
    type = "S"
  }

  attribute {
    name = "hash"
    type = "S"
  }

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }

  global_secondary_index {
    name               = "ownerId-walletId-index"
    hash_key           = "ownerId"
    range_key          = "walletId"
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "hash-index"
    hash_key           = "hash"
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "ownerId-fileId-index"
    hash_key           = "ownerId"
    range_key          = "fileId"
    projection_type    = "ALL"
  }

  tags = {
    Name        = "near-files"
    Environment = var.environment
  }

   lifecycle {
    prevent_destroy = true
    }  
}

######## SSM Parameters to be used 
resource "aws_ssm_parameter" "near-files-ddb-arn" {
  name        = "/file-service/dynamodb/files/arn"
  type        = "String"
  value       = aws_dynamodb_table.near-files.arn
}

resource "aws_ssm_parameter" "near-files-ddb-name" {
  name        = "/file-service/dynamodb/files/name"
  type        = "String"
  value       = aws_dynamodb_table.near-files.name
}

resource "aws_ssm_parameter" "near-files-ddb-stream-arn" {
  name        = "/file-service/dynamodb/files/streamArn"
  type        = "String"
  value       = aws_dynamodb_table.near-files.stream_arn
}
