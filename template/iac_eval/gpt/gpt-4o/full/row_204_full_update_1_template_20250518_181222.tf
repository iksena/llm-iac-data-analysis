To fulfill the business need, we will create a managed Amazon MSK (Managed Streaming for Apache Kafka) cluster in the AWS region `us-east-1`. The MSK cluster will be configured to log its broker logs to an S3 bucket. We will also set up the necessary IAM roles and policies to allow the MSK cluster to write logs to the S3 bucket. The configuration will include the creation of an S3 bucket, an IAM role with the appropriate permissions, and the MSK cluster itself.

<iac_template>

```hcl
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
```

</iac_template>

This configuration includes:
- An S3 bucket for storing MSK logs.
- A random ID to ensure the bucket name is unique.
- An IAM role and policy to allow MSK to write logs to the S3 bucket.
- An MSK cluster with logging enabled to the S3 bucket. The cluster is configured with three broker nodes and uses the `kafka.m5.large` instance type. The subnets and security group IDs should be replaced with actual values from your AWS environment.