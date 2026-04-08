variable "name" {
  description = "The name for the organizational unit"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_organizations_organizational_unit, name must be a non-empty string."
  }
}

variable "parent_id" {
  description = "ID of the parent organizational unit, which may be the root"
  type        = string

  validation {
    condition     = length(var.parent_id) > 0
    error_message = "resource_aws_organizations_organizational_unit, parent_id must be a non-empty string."
  }
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}