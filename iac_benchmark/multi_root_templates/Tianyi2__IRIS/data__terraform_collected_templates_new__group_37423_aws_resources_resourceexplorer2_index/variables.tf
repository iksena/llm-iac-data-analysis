variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "type" {
  description = "The type of the index. Valid values: AGGREGATOR, LOCAL."
  type        = string

  validation {
    condition     = contains(["AGGREGATOR", "LOCAL"], var.type)
    error_message = "resource_aws_resourceexplorer2_index, type must be one of: AGGREGATOR, LOCAL"
  }
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}

variable "timeout_create" {
  description = "Timeout for create operation"
  type        = string
  default     = "2h"
}

variable "timeout_update" {
  description = "Timeout for update operation"
  type        = string
  default     = "2h"
}

variable "timeout_delete" {
  description = "Timeout for delete operation"
  type        = string
  default     = "10m"
}