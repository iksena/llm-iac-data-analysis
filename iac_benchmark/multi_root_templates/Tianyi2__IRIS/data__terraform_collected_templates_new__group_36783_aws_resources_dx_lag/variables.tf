variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the LAG."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_dx_lag, name must not be empty."
  }
}

variable "connections_bandwidth" {
  description = "The bandwidth of the individual dedicated connections bundled by the LAG. Valid values: 1Gbps, 10Gbps, 100Gbps, and 400Gbps. Case sensitive."
  type        = string

  validation {
    condition     = contains(["1Gbps", "10Gbps", "100Gbps", "400Gbps"], var.connections_bandwidth)
    error_message = "resource_aws_dx_lag, connections_bandwidth must be one of: 1Gbps, 10Gbps, 100Gbps, 400Gbps (case sensitive)."
  }
}

variable "location" {
  description = "The AWS Direct Connect location in which the LAG should be allocated. Use locationCode from DescribeLocations."
  type        = string

  validation {
    condition     = length(var.location) > 0
    error_message = "resource_aws_dx_lag, location must not be empty."
  }
}

variable "connection_id" {
  description = "The ID of an existing dedicated connection to migrate to the LAG."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "A boolean that indicates all connections associated with the LAG should be deleted so that the LAG can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}

variable "provider_name" {
  description = "The name of the service provider associated with the LAG."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}