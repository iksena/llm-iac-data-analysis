variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the Billing Group."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9:_-]+$", var.name))
    error_message = "resource_aws_iot_billing_group, name must contain only alphanumeric characters, hyphens, underscores, and colons."
  }

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 128
    error_message = "resource_aws_iot_billing_group, name must be between 1 and 128 characters long."
  }
}

variable "properties" {
  description = "The Billing Group properties."
  type = object({
    description = optional(string)
  })
  default = null

  validation {
    condition = var.properties == null ? true : (
      var.properties.description == null ? true : length(var.properties.description) <= 2028
    )
    error_message = "resource_aws_iot_billing_group, properties.description must not exceed 2028 characters."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags."
  type        = map(string)
  default     = {}
}