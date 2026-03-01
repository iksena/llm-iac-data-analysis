Description:
This Terraform configuration creates a basic Amazon Kinesis stream with the name "basic-kinesis-stream". The configuration specifies one shard in the stream and sets up an AWS provider in the "us-east-1" region by default. All necessary variables and resources are declared. No undeclared resource or variable is referenced, and an IAM role isn’t strictly needed for creating a Kinesis stream.

<iac_template>
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
</iac_template>