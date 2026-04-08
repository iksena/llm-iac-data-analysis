variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "group_name" {
  description = "Name of the Availability Zone Group."
  type        = string

  validation {
    condition     = length(var.group_name) > 0
    error_message = "resource_aws_ec2_availability_zone_group, group_name must not be empty."
  }
}

variable "opt_in_status" {
  description = "Indicates whether to enable or disable Availability Zone Group. Valid values: opted-in or not-opted-in."
  type        = string

  validation {
    condition     = contains(["opted-in", "not-opted-in"], var.opt_in_status)
    error_message = "resource_aws_ec2_availability_zone_group, opt_in_status must be either 'opted-in' or 'not-opted-in'."
  }
}