variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "resource_arn" {
  description = "Amazon Resource Name (ARN) of the DynamoDB resource to tag."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:dynamodb:", var.resource_arn))
    error_message = "resource_aws_dynamodb_tag, resource_arn must be a valid DynamoDB ARN starting with 'arn:aws:dynamodb:'."
  }
}

variable "key" {
  description = "Tag name."
  type        = string

  validation {
    condition     = length(var.key) > 0 && length(var.key) <= 128
    error_message = "resource_aws_dynamodb_tag, key must be between 1 and 128 characters long."
  }
}

variable "value" {
  description = "Tag value."
  type        = string

  validation {
    condition     = length(var.value) <= 256
    error_message = "resource_aws_dynamodb_tag, value must be at most 256 characters long."
  }
}