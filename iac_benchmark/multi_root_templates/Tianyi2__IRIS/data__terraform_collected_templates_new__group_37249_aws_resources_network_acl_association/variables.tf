variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_network_acl_association, region must be a valid AWS region format (e.g., us-west-2)."
  }
}

variable "network_acl_id" {
  description = "The ID of the network ACL."
  type        = string

  validation {
    condition     = can(regex("^acl-[0-9a-f]{8,17}$", var.network_acl_id))
    error_message = "resource_aws_network_acl_association, network_acl_id must be a valid network ACL ID starting with 'acl-'."
  }
}

variable "subnet_id" {
  description = "The ID of the associated Subnet."
  type        = string

  validation {
    condition     = can(regex("^subnet-[0-9a-f]{8,17}$", var.subnet_id))
    error_message = "resource_aws_network_acl_association, subnet_id must be a valid subnet ID starting with 'subnet-'."
  }
}