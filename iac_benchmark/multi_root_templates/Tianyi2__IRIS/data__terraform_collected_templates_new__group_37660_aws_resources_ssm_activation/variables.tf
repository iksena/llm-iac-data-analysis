variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_ssm_activation, region must be a valid AWS region format."
  }
}

variable "name" {
  description = "The default name of the registered managed instance."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || length(var.name) > 0
    error_message = "resource_aws_ssm_activation, name must be a non-empty string when provided."
  }
}

variable "description" {
  description = "The description of the resource that you want to register."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) > 0
    error_message = "resource_aws_ssm_activation, description must be a non-empty string when provided."
  }
}

variable "expiration_date" {
  description = "UTC timestamp in RFC3339 format by which this activation request should expire. The default value is 24 hours from resource creation time."
  type        = string
  default     = null

  validation {
    condition     = var.expiration_date == null || can(formatdate("2006-01-02T15:04:05Z", var.expiration_date))
    error_message = "resource_aws_ssm_activation, expiration_date must be in RFC3339 format (YYYY-MM-DDTHH:MM:SSZ)."
  }
}

variable "iam_role" {
  description = "The IAM Role to attach to the managed instance."
  type        = string

  validation {
    condition     = length(var.iam_role) > 0
    error_message = "resource_aws_ssm_activation, iam_role is required and must be a non-empty string."
  }
}

variable "registration_limit" {
  description = "The maximum number of managed instances you want to register. The default value is 1 instance."
  type        = number
  default     = null

  validation {
    condition     = var.registration_limit == null || var.registration_limit > 0
    error_message = "resource_aws_ssm_activation, registration_limit must be a positive number when provided."
  }
}

variable "tags" {
  description = "A map of tags to assign to the object."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : length(k) > 0 && length(v) >= 0])
    error_message = "resource_aws_ssm_activation, tags keys must be non-empty strings."
  }
}