variable "contact_flow_id" {
  description = "Contact flow ID"
  type        = string

  validation {
    condition     = length(var.contact_flow_id) > 0
    error_message = "resource_aws_connect_phone_number_contact_flow_association, contact_flow_id must not be empty."
  }
}

variable "instance_id" {
  description = "Amazon Connect instance ID"
  type        = string

  validation {
    condition     = length(var.instance_id) > 0
    error_message = "resource_aws_connect_phone_number_contact_flow_association, instance_id must not be empty."
  }
}

variable "phone_number_id" {
  description = "Phone number ID"
  type        = string

  validation {
    condition     = length(var.phone_number_id) > 0
    error_message = "resource_aws_connect_phone_number_contact_flow_association, phone_number_id must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_connect_phone_number_contact_flow_association, region must be a valid AWS region format."
  }
}