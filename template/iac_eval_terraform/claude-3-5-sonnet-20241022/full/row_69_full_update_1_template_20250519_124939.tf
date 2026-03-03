I'll help you create a Terraform configuration to manage an AWS Kinesis Stream Consumer. This configuration will create a Kinesis stream and a stream consumer that can be used by applications to process data from the stream using enhanced fan-out. The consumer will be registered with the Kinesis stream and will have its own dedicated throughput, allowing for better scaling and performance.

Here's the Terraform configuration:

<iac_template>
# Configure AWS Provider
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
</iac_template>

This Terraform configuration does the following:

1. Sets up the AWS provider for the us-west-2 region
2. Defines variables for the stream and consumer names with default values
3. Creates a Kinesis stream with:
   - 1 shard
   - 24-hour retention period
   - PROVISIONED stream mode
   - Appropriate tags
4. Creates a Kinesis stream consumer associated with the stream
5. Outputs useful information including:
   - Stream ARN
   - Consumer ARN
   - Consumer creation timestamp

The configuration is complete and deployable. To use it, you can either:
- Use the default values for the stream and consumer names
- Override the variables by providing your own values through terraform.tfvars or command line arguments

The consumer will be registered with the Kinesis stream and can be used by applications that need dedicated throughput for processing data from the stream using enhanced fan-out capabilities.