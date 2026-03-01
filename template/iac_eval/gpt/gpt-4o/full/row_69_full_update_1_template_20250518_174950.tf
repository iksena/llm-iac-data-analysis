To manage a Kinesis Stream Consumer using Terraform, we will create a configuration that includes the AWS provider setup, a Kinesis data stream, and a Kinesis stream consumer. The configuration will define the necessary resources to create a Kinesis data stream and a consumer that can read from this stream. We will also ensure that the necessary IAM roles and policies are in place to allow the consumer to access the stream.

Here is the Terraform configuration:

<iac_template>
```hcl
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
```
</iac_template>

This configuration sets up a Kinesis data stream named "example-stream" with a single shard and a retention period of 24 hours. It also creates an IAM role and policy to allow a Kinesis stream consumer to access the stream. The consumer is then created and associated with the stream.