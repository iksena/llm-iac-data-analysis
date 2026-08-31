######### Files Table (name=near-files-invitations)
resource "aws_dynamodb_table" "near-files-invitations" {
  name           = "near-files-invitations"
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

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }

  tags = {
    Name        = "near-files-invitations"
    Environment = var.environment
  }

   lifecycle {
    prevent_destroy = true
    }  
}

######### SSM Parameters to be used 
resource "aws_ssm_parameter" "near-files-invitations-ddb-arn" {
  name        = "/file-service/dynamodb/invitations/arn"
  type        = "String"
  value       = aws_dynamodb_table.near-files-invitations.arn
}

resource "aws_ssm_parameter" "near-files-invitations-ddb-name" {
  name        = "/file-service/dynamodb/invitations/name"
  type        = "String"
  value       = aws_dynamodb_table.near-files-invitations.name
}

resource "aws_ssm_parameter" "near-files-invitations-ddb-stream-arn" {
  name        = "/file-service/dynamodb/invitations/streamArn"
  type        = "String"
  value       = aws_dynamodb_table.near-files-invitations.stream_arn
}
