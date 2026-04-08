variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the Profile"
  type        = string

  validation {
    condition     = var.name != null && var.name != ""
    error_message = "resource_aws_route53profiles_profile, name cannot be null or empty."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "timeouts_create" {
  description = "Timeout for create operations"
  type        = string
  default     = "30m"
}

variable "timeouts_read" {
  description = "Timeout for read operations"
  type        = string
  default     = "30m"
}

variable "timeouts_update" {
  description = "Timeout for update operations"
  type        = string
  default     = "30m"
}

variable "timeouts_delete" {
  description = "Timeout for delete operations"
  type        = string
  default     = "30m"
}