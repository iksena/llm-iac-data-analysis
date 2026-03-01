provider "aws" {
  region = "us-east-1"
}

# Variables with default values
variable "table_name" {
  description = "Name of the DynamoDB table"
  default     = "my-dynamodb-table"
}

variable "stream_name" {
  description = "Name of the Kinesis stream"
  default     = "my-kinesis-stream"
}

# DynamoDB table
resource "aws_dynamodb_table" "main" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "id"
    type = "S"
  }
}

# Kinesis stream
resource "aws_kinesis_stream" "main" {
  name             = var.stream_name
  shard_count      = 1
  retention_period = 24

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }
}

# IAM role for DynamoDB to Kinesis
resource "aws_iam_role" "dynamodb_kinesis_role" {
  name = "dynamodb-kinesis-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "dynamodb.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy for DynamoDB to write to Kinesis
resource "aws_iam_role_policy" "dynamodb_kinesis_policy" {
  name = "dynamodb-kinesis-policy"
  role = aws_iam_role.dynamodb_kinesis_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kinesis:PutRecord",
          "kinesis:PutRecords",
          "kinesis:DescribeStream",
          "kinesis:ListShards"
        ]
        Resource = aws_kinesis_stream.main.arn
      }
    ]
  })
}

# DynamoDB Kinesis Streaming Destination
resource "aws_dynamodb_kinesis_streaming_destination" "example" {
  stream_arn = aws_kinesis_stream.main.arn
  table_name = aws_dynamodb_table.main.name
}