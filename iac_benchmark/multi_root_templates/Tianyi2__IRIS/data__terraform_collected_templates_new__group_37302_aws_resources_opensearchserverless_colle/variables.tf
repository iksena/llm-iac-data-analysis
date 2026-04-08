variable "name" {
  description = "Name of the collection"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_opensearchserverless_collection, name must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the collection"
  type        = string
  default     = null
}

variable "standby_replicas" {
  description = "Indicates whether standby replicas should be used for a collection"
  type        = string
  default     = "ENABLED"

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.standby_replicas)
    error_message = "resource_aws_opensearchserverless_collection, standby_replicas must be either ENABLED or DISABLED."
  }
}

variable "tags" {
  description = "A map of tags to assign to the collection"
  type        = map(string)
  default     = {}
}

variable "type" {
  description = "Type of collection"
  type        = string
  default     = "TIMESERIES"

  validation {
    condition     = contains(["SEARCH", "TIMESERIES", "VECTORSEARCH"], var.type)
    error_message = "resource_aws_opensearchserverless_collection, type must be one of SEARCH, TIMESERIES, or VECTORSEARCH."
  }
}

variable "create_timeout" {
  description = "Timeout for create operations"
  type        = string
  default     = "20m"
}

variable "delete_timeout" {
  description = "Timeout for delete operations"
  type        = string
  default     = "20m"
}