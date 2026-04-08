variable "name" {
  description = "Friendly name of the topic to match"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_sns_topic, name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_sns_topic, region must be a valid AWS region format."
  }
}