provider "aws" {
  region = "us-east-1"
}

resource "aws_dynamodb_table" "example" {
  name           = "example-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_kinesis_stream" "example" {
  name        = "example-stream"
  shard_count = 1
}

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

resource "aws_iam_role_policy" "dynamodb_kinesis_policy" {
  name = "dynamodb-kinesis-policy"
  role = aws_iam_role.dynamodb_kinesis_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kinesis:DescribeStream",
          "kinesis:PutRecord",
          "kinesis:PutRecords"
        ]
        Effect   = "Allow"
        Resource = aws_kinesis_stream.example.arn
      }
    ]
  })
}

resource "aws_dynamodb_kinesis_streaming_destination" "example" {
  table_name   = aws_dynamodb_table.example.name
  stream_arn   = aws_kinesis_stream.example.arn
  role_arn     = aws_iam_role.dynamodb_kinesis_role.arn
}