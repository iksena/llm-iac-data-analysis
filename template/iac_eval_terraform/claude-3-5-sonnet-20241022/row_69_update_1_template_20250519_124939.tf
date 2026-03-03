provider "aws" {
  region = "us-west-2"
}

# Variables
variable "stream_name" {
  description = "Name of the Kinesis stream"
  type        = string
  default     = "example-stream"
}

variable "consumer_name" {
  description = "Name of the Kinesis stream consumer"
  type        = string
  default     = "example-consumer"
}

# Create Kinesis Stream
resource "aws_kinesis_stream" "example" {
  name             = var.stream_name
  shard_count      = 1
  retention_period = 24

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }

  tags = {
    Environment = "development"
    Purpose     = "data-streaming"
  }
}

# Create Kinesis Stream Consumer
resource "aws_kinesis_stream_consumer" "example" {
  name       = var.consumer_name
  stream_arn = aws_kinesis_stream.example.arn

  depends_on = [aws_kinesis_stream.example]
}

# Output values
output "stream_arn" {
  description = "The ARN of the Kinesis stream"
  value       = aws_kinesis_stream.example.arn
}

output "consumer_arn" {
  description = "The ARN of the Kinesis stream consumer"
  value       = aws_kinesis_stream_consumer.example.arn
}

output "consumer_creation_timestamp" {
  description = "Timestamp when the consumer was created"
  value       = aws_kinesis_stream_consumer.example.creation_timestamp
}