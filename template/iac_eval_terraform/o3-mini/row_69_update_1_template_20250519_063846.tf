terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0.0"
    }
  }
  required_version = ">= 0.14.0"
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy resources."
  type        = string
  default     = "us-east-1"
}

variable "stream_name" {
  description = "The name of the Kinesis stream."
  type        = string
  default     = "example-kinesis-stream"
}

variable "consumer_name" {
  description = "The name of the Kinesis stream consumer."
  type        = string
  default     = "example-consumer"
}

variable "shard_count" {
  description = "Number of shards for the Kinesis stream."
  type        = number
  default     = 1
}

resource "aws_kinesis_stream" "example" {
  name         = var.stream_name
  shard_count  = var.shard_count
  retention_period = 24 # retention period in hours, example value
}

resource "aws_kinesis_stream_consumer" "example_consumer" {
  name       = var.consumer_name
  stream_arn = aws_kinesis_stream.example.arn
}