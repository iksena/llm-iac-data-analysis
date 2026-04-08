variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_cloudwatch_log_destination, region must be a valid AWS region format."
  }
}

variable "name" {
  description = "A name for the log destination"
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 512
    error_message = "resource_aws_cloudwatch_log_destination, name must be between 1 and 512 characters."
  }
}

variable "role_arn" {
  description = "The ARN of an IAM role that grants Amazon CloudWatch Logs permissions to put data into the target"
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/.+", var.role_arn))
    error_message = "resource_aws_cloudwatch_log_destination, role_arn must be a valid IAM role ARN."
  }
}

variable "target_arn" {
  description = "The ARN of the target Amazon Kinesis stream resource for the destination"
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:kinesis:[a-z0-9-]+:[0-9]{12}:stream/.+", var.target_arn))
    error_message = "resource_aws_cloudwatch_log_destination, target_arn must be a valid Kinesis stream ARN."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : length(k) <= 128 && length(v) <= 256])
    error_message = "resource_aws_cloudwatch_log_destination, tags keys must be 128 characters or less and values must be 256 characters or less."
  }
}