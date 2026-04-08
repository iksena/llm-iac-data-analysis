variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_ec2_managed_prefix_list_entry, region must be a valid AWS region identifier."
  }
}

variable "cidr" {
  description = "CIDR block of this entry."
  type        = string

  validation {
    condition     = can(cidrhost(var.cidr, 0))
    error_message = "resource_aws_ec2_managed_prefix_list_entry, cidr must be a valid CIDR block."
  }
}

variable "description" {
  description = "Description of this entry. Please note that due to API limitations, updating only the description of an entry will require recreating the entry."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 255
    error_message = "resource_aws_ec2_managed_prefix_list_entry, description must be 255 characters or less."
  }
}

variable "prefix_list_id" {
  description = "The ID of the prefix list."
  type        = string

  validation {
    condition     = can(regex("^pl-[a-f0-9]{8,17}$", var.prefix_list_id))
    error_message = "resource_aws_ec2_managed_prefix_list_entry, prefix_list_id must be a valid prefix list ID starting with 'pl-'."
  }
}