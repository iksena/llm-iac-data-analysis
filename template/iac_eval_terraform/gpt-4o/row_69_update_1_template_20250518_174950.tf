provider "aws" {
  region = "us-west-2"
}

resource "aws_kinesis_stream" "example_stream" {
  name             = "example-stream"
  shard_count      = 1
  retention_period = 24
}

resource "aws_iam_role" "kinesis_consumer_role" {
  name = "kinesis-consumer-role"

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

resource "aws_iam_policy" "kinesis_consumer_policy" {
  name        = "kinesis-consumer-policy"
  description = "Policy for Kinesis Stream Consumer"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kinesis:DescribeStream",
          "kinesis:GetRecords",
          "kinesis:GetShardIterator",
          "kinesis:ListStreams",
          "kinesis:SubscribeToShard"
        ]
        Effect   = "Allow"
        Resource = aws_kinesis_stream.example_stream.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "kinesis_consumer_policy_attach" {
  role       = aws_iam_role.kinesis_consumer_role.name
  policy_arn = aws_iam_policy.kinesis_consumer_policy.arn
}

resource "aws_kinesis_stream_consumer" "example_consumer" {
  name           = "example-consumer"
  stream_arn     = aws_kinesis_stream.example_stream.arn
  consumer_arn   = aws_iam_role.kinesis_consumer_role.arn
}