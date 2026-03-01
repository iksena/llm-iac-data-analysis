To fulfill the business need, we will create a managed Amazon MSK (Managed Streaming for Apache Kafka) cluster in the AWS region `us-east-1`. We will also set up a Kinesis Firehose delivery stream to capture the logs from the MSK cluster. The configuration will include the necessary IAM roles and policies to allow MSK to log to the Kinesis Firehose. The MSK cluster will be configured with basic settings, and the Firehose delivery stream will be set to deliver logs to an S3 bucket for storage.

<iac_template>
```hcl
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
```
</iac_template>

This configuration sets up an MSK cluster with logging enabled to a Kinesis Firehose delivery stream, which then stores the logs in an S3 bucket. The necessary IAM roles and policies are created to allow the Firehose to write to the S3 bucket. Make sure to replace the subnet IDs and security group IDs with your actual network configuration.