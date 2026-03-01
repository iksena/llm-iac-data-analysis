provider "aws" {
  region = "us-east-1"
}

# Create Kinesis Data Stream
resource "aws_kinesis_stream" "demo_stream" {
  name             = "demo-stream"
  shard_count      = 1
  retention_period = 24

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }

  encryption_type = "KMS"
  kms_key_id     = "alias/aws/kinesis"

  tags = {
    Environment = "demo"
    Purpose     = "data-streaming"
  }
}

# Output the Stream ARN
output "kinesis_stream_arn" {
  value       = aws_kinesis_stream.demo_stream.arn
  description = "The ARN of the Kinesis Stream"
}

# Output the Stream Name
output "kinesis_stream_name" {
  value       = aws_kinesis_stream.demo_stream.name
  description = "The name of the Kinesis Stream"
}