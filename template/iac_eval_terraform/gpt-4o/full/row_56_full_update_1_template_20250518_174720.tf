To create a basic Amazon Kinesis stream using Terraform, we will define a Terraform configuration that sets up an AWS Kinesis Data Stream. This configuration will include the necessary provider configuration for AWS, specify the region, and create a Kinesis stream with a specified number of shards. We will also include an IAM role with the necessary permissions to interact with the Kinesis stream.

<iac_template>

```hcl
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
```

</iac_template>

This Terraform configuration sets up a Kinesis stream named "example-stream" with one shard and a retention period of 24 hours. It also creates an IAM role with a policy that allows basic operations on the Kinesis stream, such as putting and getting records. The IAM role is assumed by the Kinesis service.