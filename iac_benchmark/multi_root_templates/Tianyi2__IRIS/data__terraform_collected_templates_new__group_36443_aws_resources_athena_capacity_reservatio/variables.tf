variable "name" {
  description = "Name of the capacity reservation."
  type        = string
}

variable "target_dpus" {
  description = "Number of data processing units requested. Must be at least 24 units."
  type        = number
  validation {
    condition     = var.target_dpus >= 24
    error_message = "resource_aws_athena_capacity_reservation, target_dpus must be at least 24 units."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags assigned to the resource."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Timeouts configuration for the resource"
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = null
}