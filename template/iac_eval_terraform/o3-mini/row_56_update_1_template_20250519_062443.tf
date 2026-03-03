provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

resource "aws_kinesis_stream" "basic_stream" {
  name        = "basic-kinesis-stream"
  shard_count = 1

  retention_period = 24  # Optional: Default retention period in hours, can be adjusted if needed
}