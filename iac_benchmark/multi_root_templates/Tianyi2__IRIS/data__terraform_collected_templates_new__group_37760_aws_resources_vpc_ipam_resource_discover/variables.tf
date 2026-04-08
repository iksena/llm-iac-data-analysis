variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "ipam_id" {
  description = "The ID of the IPAM to associate."
  type        = string

  validation {
    condition     = length(var.ipam_id) > 0
    error_message = "resource_aws_vpc_ipam_resource_discovery_association, ipam_id cannot be empty."
  }

  validation {
    condition     = can(regex("^ipam-[a-f0-9]+$", var.ipam_id))
    error_message = "resource_aws_vpc_ipam_resource_discovery_association, ipam_id must be a valid IPAM ID format (ipam-xxxxxxxxx)."
  }
}

variable "ipam_resource_discovery_id" {
  description = "The ID of the Resource Discovery to associate."
  type        = string

  validation {
    condition     = length(var.ipam_resource_discovery_id) > 0
    error_message = "resource_aws_vpc_ipam_resource_discovery_association, ipam_resource_discovery_id cannot be empty."
  }

  validation {
    condition     = can(regex("^ipam-res-disco-[a-f0-9]+$", var.ipam_resource_discovery_id))
    error_message = "resource_aws_vpc_ipam_resource_discovery_association, ipam_resource_discovery_id must be a valid IPAM Resource Discovery ID format (ipam-res-disco-xxxxxxxxx)."
  }
}

variable "tags" {
  description = "A map of tags to add to the IPAM resource discovery association resource."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^.{1,128}$", k))])
    error_message = "resource_aws_vpc_ipam_resource_discovery_association, tags keys must be between 1 and 128 characters."
  }

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^.{0,256}$", v))])
    error_message = "resource_aws_vpc_ipam_resource_discovery_association, tags values must be between 0 and 256 characters."
  }
}