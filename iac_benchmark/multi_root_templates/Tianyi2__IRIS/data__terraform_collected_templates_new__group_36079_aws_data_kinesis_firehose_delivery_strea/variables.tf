variable "name" {
  description = "Name of the Kinesis Firehose Delivery Stream"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_kinesis_firehose_delivery_stream, name cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_kinesis_firehose_delivery_stream, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}