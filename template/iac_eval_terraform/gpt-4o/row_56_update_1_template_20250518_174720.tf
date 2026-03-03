provider "aws" {
  region = "us-east-1"
}

resource "aws_kinesis_stream" "example" {
  name             = "example-stream"
  shard_count      = 1
  retention_period = 24

  tags = {
    Environment = "dev"
    Name        = "example-stream"
  }
}

resource "aws_iam_role" "kinesis_role" {
  name = "kinesis-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "kinesis.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "kinesis_policy" {
  name        = "kinesis-policy"
  description = "Policy for Kinesis stream access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kinesis:PutRecord",
          "kinesis:PutRecords",
          "kinesis:GetShardIterator",
          "kinesis:GetRecords",
          "kinesis:DescribeStream",
          "kinesis:ListStreams"
        ]
        Effect   = "Allow"
        Resource = aws_kinesis_stream.example.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "kinesis_role_attach" {
  role       = aws_iam_role.kinesis_role.name
  policy_arn = aws_iam_policy.kinesis_policy.arn
}