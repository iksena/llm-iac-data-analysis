provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "msk_logs" {
  bucket = "msk-logs-bucket-${random_id.bucket_id.hex}"
  acl    = "private"

  tags = {
    Name = "MSK Logs Bucket"
  }
}

resource "random_id" "bucket_id" {
  byte_length = 8
}

resource "aws_iam_role" "msk_logging_role" {
  name = "MSKLoggingRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "kafka.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "msk_logging_policy" {
  name        = "MSKLoggingPolicy"
  description = "Policy to allow MSK to log to S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Resource = "${aws_s3_bucket.msk_logs.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "msk_logging_policy_attachment" {
  role       = aws_iam_role.msk_logging_role.name
  policy_arn = aws_iam_policy.msk_logging_policy.arn
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
    security_groups = ["sg-0123456789abcdef0"]
  }

  logging_info {
    broker_logs {
      s3 {
        bucket     = aws_s3_bucket.msk_logs.bucket
        enabled    = true
        prefix     = "logs/"
      }
    }
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
  }
}