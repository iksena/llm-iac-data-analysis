variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "filter" {
  description = "Custom filter block"
  type = list(object({
    name   = string
    values = set(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_vpc_endpoint, filter: name is required and cannot be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_vpc_endpoint, filter: values must contain at least one value."
  }
}

variable "id" {
  description = "ID of the specific VPC Endpoint to retrieve"
  type        = string
  default     = null
}

variable "service_name" {
  description = "Service name of the specific VPC Endpoint to retrieve. For AWS services the service name is usually in the form com.amazonaws.<region>.<service>"
  type        = string
  default     = null
}

variable "state" {
  description = "State of the specific VPC Endpoint to retrieve"
  type        = string
  default     = null

  validation {
    condition = var.state == null || contains([
      "PendingAcceptance",
      "Pending",
      "Available",
      "Deleting",
      "Deleted",
      "Rejected",
      "Failed",
      "Expired"
    ], var.state)
    error_message = "data_aws_vpc_endpoint, state: must be one of PendingAcceptance, Pending, Available, Deleting, Deleted, Rejected, Failed, or Expired."
  }
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the specific VPC Endpoint to retrieve"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID of the VPC in which the specific VPC Endpoint is used"
  type        = string
  default     = null

  validation {
    condition     = var.vpc_id == null || can(regex("^vpc-[0-9a-f]{8,17}$", var.vpc_id))
    error_message = "data_aws_vpc_endpoint, vpc_id: must be a valid VPC ID format (vpc-xxxxxxxx)."
  }
}