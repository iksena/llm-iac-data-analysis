provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "firehose_delivery_role" {
  name = "FirehoseDeliveryRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "firehose_delivery_policy" {
  name        = "FirehoseDeliveryPolicy"
  description = "Policy for Firehose to deliver logs to S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::my-msk-logs-bucket/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "firehose_policy_attachment" {
  role       = aws_iam_role.firehose_delivery_role.name
  policy_arn = aws_iam_policy.firehose_delivery_policy.arn
}

resource "aws_s3_bucket" "msk_logs_bucket" {
  bucket = "my-msk-logs-bucket"
  acl    = "private"
}

resource "aws_kinesis_firehose_delivery_stream" "msk_logs_stream" {
  name        = "MSKLogsStream"
  destination = "s3"

  s3_configuration {
    role_arn   = aws_iam_role.firehose_delivery_role.arn
    bucket_arn = aws_s3_bucket.msk_logs_bucket.arn
  }
}

resource "aws_msk_cluster" "example" {
  cluster_name           = "example-cluster"
  kafka_version          = "2.8.1"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type = "kafka.m5.large"
    client_subnets = [
      "subnet-0123456789abcdef0",
      "subnet-0123456789abcdef1",
      "subnet-0123456789abcdef2"
    ]
    security_groups = [
      "sg-0123456789abcdef0"
    ]
  }

  logging_info {
    broker_logs {
      firehose {
        enabled         = true
        delivery_stream = aws_kinesis_firehose_delivery_stream.msk_logs_stream.name
      }
    }
  }
}