variable "availability_zone" {
  description = "The Availability Zone for the default subnet"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+[a-z]$", var.availability_zone))
    error_message = "resource_aws_default_subnet, availability_zone must be a valid AWS Availability Zone (e.g., us-west-2a)."
  }
}

variable "force_destroy" {
  description = "Whether destroying the resource deletes the default subnet"
  type        = bool
  default     = false

  validation {
    condition     = can(tobool(var.force_destroy))
    error_message = "resource_aws_default_subnet, force_destroy must be a boolean value."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}

  validation {
    condition     = can(tomap(var.tags))
    error_message = "resource_aws_default_subnet, tags must be a map of strings."
  }
}