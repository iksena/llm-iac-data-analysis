######## Wallets Table (name=near-wallets)
resource "aws_dynamodb_table" "near-wallets" {
  name         = "near-wallets"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "walletId"
  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "walletId"
    type = "S"
  }

  attribute {
    name = "walletName"
    type = "S"
  }

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "jobId"
    type = "S"
  }

  global_secondary_index {
    name               = "userId-Index"
    hash_key           = "userId"
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "walletName-Index"
    hash_key           = "walletName"
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "jobId-Index"
    hash_key           = "jobId"
    projection_type    = "ALL"
  }

  tags = {
    Name        = "near-wallets"
    Environment = var.environment
  }

   lifecycle {
    prevent_destroy = true
    }  
}

######## SSM Parameters to be used
resource "aws_ssm_parameter" "near-wallets-table-arn" {
  name        = "/wallet-service/dynamodb/wallets/arn"
  type        = "String"
  value       = aws_dynamodb_table.near-wallets.arn
}

resource "aws_ssm_parameter" "near-wallets-table-name" {
  name        = "/wallet-service/dynamodb/wallets/name"
  type        = "String"
  value       = aws_dynamodb_table.near-wallets.name
}

resource "aws_ssm_parameter" "near-wallets-table-stream-arn" {
  name        = "/wallet-service/dynamodb/wallets/streamArn"
  type        = "String"
  value       = aws_dynamodb_table.near-wallets.stream_arn
}
