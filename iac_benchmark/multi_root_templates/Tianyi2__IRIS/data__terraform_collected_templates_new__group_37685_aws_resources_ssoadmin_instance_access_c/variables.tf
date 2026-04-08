variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "instance_arn" {
  description = "The Amazon Resource Name (ARN) of the SSO Instance."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:sso:::instance/ssoins-[0-9a-f]{16}$", var.instance_arn))
    error_message = "resource_aws_ssoadmin_instance_access_control_attributes, instance_arn must be a valid SSO instance ARN in the format: arn:aws:sso:::instance/ssoins-[16 character hex string]."
  }
}

variable "attributes" {
  description = "List of access control attributes. Each attribute contains a key and value with source."
  type = list(object({
    key = string
    value = object({
      source = list(string)
    })
  }))

  validation {
    condition     = length(var.attributes) > 0
    error_message = "resource_aws_ssoadmin_instance_access_control_attributes, attributes must contain at least one attribute."
  }

  validation {
    condition = alltrue([
      for attr in var.attributes : attr.key != null && attr.key != ""
    ])
    error_message = "resource_aws_ssoadmin_instance_access_control_attributes, attributes each attribute key must be a non-empty string."
  }

  validation {
    condition = alltrue([
      for attr in var.attributes : length(attr.value.source) > 0
    ])
    error_message = "resource_aws_ssoadmin_instance_access_control_attributes, attributes each attribute value source must contain at least one source."
  }

  validation {
    condition = alltrue([
      for attr in var.attributes : alltrue([
        for source in attr.value.source : source != null && source != ""
      ])
    ])
    error_message = "resource_aws_ssoadmin_instance_access_control_attributes, attributes each source in attribute value must be a non-empty string."
  }
}