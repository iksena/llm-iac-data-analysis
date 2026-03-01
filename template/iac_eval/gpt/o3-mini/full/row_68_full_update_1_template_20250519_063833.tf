Description:
This Terraform configuration sets up a basic AWS Kinesis Video Stream. It includes the AWS provider configuration, necessary variables (with default values) for region, stream name, and data retention period, and creates a Kinesis Video Stream resource with the provided configuration.

<iac_template>
provider "aws" {
  region = var.region
}

variable "region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

variable "stream_name" {
  description = "The name of the Kinesis Video Stream."
  type        = string
  default     = "my-kinesis-video-stream"
}

variable "data_retention_in_hours" {
  description = "The number of hours data is retained in the stream."
  type        = number
  default     = 24
}

resource "aws_kinesis_video_stream" "kinesis_video_stream" {
  name                    = var.stream_name
  data_retention_in_hours = var.data_retention_in_hours
}
</iac_template>