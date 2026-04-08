variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cascade" {
  description = "Enables you to quickly delete an IPAM, private scopes, pools in private scopes, and any allocations in the pools in private scopes."
  type        = bool
  default     = null
}

variable "description" {
  description = "A description for the IPAM."
  type        = string
  default     = null
}

variable "enable_private_gua" {
  description = "Enable this option to use your own GUA ranges as private IPv6 addresses."
  type        = bool
  default     = false
}

variable "metered_account" {
  description = "AWS account that is charged for active IP addresses managed in IPAM. Valid values are ipam-owner and resource-owner."
  type        = string
  default     = "ipam-owner"

  validation {
    condition     = var.metered_account == null ? true : contains(["ipam-owner", "resource-owner"], var.metered_account)
    error_message = "resource_aws_vpc_ipam, metered_account must be one of: ipam-owner, resource-owner."
  }
}

variable "operating_regions" {
  description = "Determines which locales can be chosen when you create pools. You must set your provider block region as an operating_region."
  type = list(object({
    region_name = string
  }))

  validation {
    condition     = length(var.operating_regions) > 0
    error_message = "resource_aws_vpc_ipam, operating_regions must contain at least one region."
  }

  validation {
    condition = alltrue([
      for region in var.operating_regions : region.region_name != null && region.region_name != ""
    ])
    error_message = "resource_aws_vpc_ipam, operating_regions region_name cannot be null or empty."
  }
}

variable "tier" {
  description = "Specifies the IPAM tier. Valid options include free and advanced."
  type        = string
  default     = "advanced"

  validation {
    condition     = var.tier == null ? true : contains(["free", "advanced"], var.tier)
    error_message = "resource_aws_vpc_ipam, tier must be one of: free, advanced."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}