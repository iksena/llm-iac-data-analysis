variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "resource_id" {
  description = "The ID of the EC2 resource to manage the tag for."
  type        = string

  validation {
    condition     = length(var.resource_id) > 0
    error_message = "resource_aws_ec2_tag, resource_id must not be empty."
  }
}

variable "key" {
  description = "The tag name."
  type        = string

  validation {
    condition     = length(var.key) > 0
    error_message = "resource_aws_ec2_tag, key must not be empty."
  }
}

variable "value" {
  description = "The value of the tag."
  type        = string

  validation {
    condition     = length(var.value) > 0
    error_message = "resource_aws_ec2_tag, value must not be empty."
  }
}