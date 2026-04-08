variable "force_destroy" {
  description = "Whether destroying the resource deletes the default VPC"
  type        = bool
  default     = false

  validation {
    condition     = can(var.force_destroy)
    error_message = "resource_aws_default_vpc, force_destroy must be a boolean value."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}

  validation {
    condition     = can(var.tags)
    error_message = "resource_aws_default_vpc, tags must be a map of strings."
  }
}