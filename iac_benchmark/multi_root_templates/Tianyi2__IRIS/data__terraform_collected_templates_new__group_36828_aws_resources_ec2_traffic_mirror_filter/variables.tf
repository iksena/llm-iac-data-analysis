variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "A description of the filter. Forces new resource."
  type        = string
  default     = null
}

variable "network_services" {
  description = "List of amazon network services that should be mirrored. Valid values: amazon-dns."
  type        = list(string)
  default     = null

  validation {
    condition = var.network_services == null || alltrue([
      for service in var.network_services : contains(["amazon-dns"], service)
    ])
    error_message = "resource_aws_ec2_traffic_mirror_filter, network_services must contain only valid values: amazon-dns."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = null
}