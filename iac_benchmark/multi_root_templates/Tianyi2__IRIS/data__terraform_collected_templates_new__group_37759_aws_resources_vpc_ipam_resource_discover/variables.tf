variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "A description for the IPAM Resource Discovery."
  type        = string
  default     = null
}

variable "operating_regions" {
  description = "Determines which regions the Resource Discovery will enable IPAM features for usage and monitoring. You must set your provider block region as an operating_region."
  type = list(object({
    region_name = string
  }))

  validation {
    condition     = length(var.operating_regions) > 0
    error_message = "resource_aws_vpc_ipam_resource_discovery, operating_regions must contain at least one operating region."
  }

  validation {
    condition = alltrue([
      for region in var.operating_regions : region.region_name != null && region.region_name != ""
    ])
    error_message = "resource_aws_vpc_ipam_resource_discovery, operating_regions each region_name must be a non-empty string."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}