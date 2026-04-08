variable "filter" {
  description = "Configuration block(s) for filtering. Each filter must have a name and values."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_vpc_endpoint_service, filter: filter name cannot be null or empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_vpc_endpoint_service, filter: filter values cannot be empty."
  }
}

variable "service" {
  description = "Common name of an AWS service (e.g., s3)."
  type        = string
  default     = null

  validation {
    condition = var.service == null || (
      var.service != null && var.service != ""
    )
    error_message = "data_aws_vpc_endpoint_service, service: service name cannot be empty string."
  }
}

variable "service_name" {
  description = "Service name that is specified when creating a VPC endpoint. For AWS services the service name is usually in the form com.amazonaws.<region>.<service>."
  type        = string
  default     = null

  validation {
    condition = var.service_name == null || (
      var.service_name != null && var.service_name != ""
    )
    error_message = "data_aws_vpc_endpoint_service, service_name: service_name cannot be empty string."
  }
}

variable "service_regions" {
  description = "AWS regions in which to look for services."
  type        = list(string)
  default     = null

  validation {
    condition = var.service_regions == null || (
      var.service_regions != null && length(var.service_regions) > 0 && alltrue([
        for region in var.service_regions : region != null && region != ""
      ])
    )
    error_message = "data_aws_vpc_endpoint_service, service_regions: all regions must be non-empty strings."
  }
}

variable "service_type" {
  description = "Service type, Gateway or Interface."
  type        = string
  default     = null

  validation {
    condition     = var.service_type == null || contains(["Gateway", "Interface"], var.service_type)
    error_message = "data_aws_vpc_endpoint_service, service_type: must be either 'Gateway' or 'Interface'."
  }
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the desired VPC Endpoint Service."
  type        = map(string)
  default     = null

  validation {
    condition = var.tags == null || (
      var.tags != null && alltrue([
        for k, v in var.tags : k != null && k != "" && v != null
      ])
    )
    error_message = "data_aws_vpc_endpoint_service, tags: tag keys cannot be null or empty, tag values cannot be null."
  }
}

variable "timeouts_read" {
  description = "Timeout for read operations."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_read))
    error_message = "data_aws_vpc_endpoint_service, timeouts_read: must be a valid duration string (e.g., '20m', '1h', '30s')."
  }
}