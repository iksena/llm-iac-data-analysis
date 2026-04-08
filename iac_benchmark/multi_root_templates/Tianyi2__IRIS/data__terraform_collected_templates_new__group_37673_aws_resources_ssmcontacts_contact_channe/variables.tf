variable "contact_id" {
  description = "Amazon Resource Name (ARN) of the AWS SSM Contact that the contact channel belongs to"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:ssm-contacts:", var.contact_id))
    error_message = "resource_aws_ssmcontacts_contact_channel, contact_id must be a valid SSM Contacts ARN starting with 'arn:aws:ssm-contacts:'."
  }
}

variable "delivery_address_simple_address" {
  description = "Details to engage this contact channel. The expected format depends on the contact channel type"
  type        = string

  validation {
    condition     = length(var.delivery_address_simple_address) > 0
    error_message = "resource_aws_ssmcontacts_contact_channel, delivery_address_simple_address cannot be empty."
  }
}

variable "name" {
  description = "Name of the contact channel. Must be between 1 and 255 characters, and may contain alphanumerics, underscores (_), hyphens (-), periods (.), and spaces"
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 255
    error_message = "resource_aws_ssmcontacts_contact_channel, name must be between 1 and 255 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9_\\-\\. ]+$", var.name))
    error_message = "resource_aws_ssmcontacts_contact_channel, name may only contain alphanumerics, underscores (_), hyphens (-), periods (.), and spaces."
  }
}

variable "type" {
  description = "Type of the contact channel"
  type        = string

  validation {
    condition     = contains(["SMS", "VOICE", "EMAIL"], var.type)
    error_message = "resource_aws_ssmcontacts_contact_channel, type must be one of: SMS, VOICE, EMAIL."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}