variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "data_aws_security_groups, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match for desired security groups."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^.{1,128}$", k)) && can(regex("^.{0,256}$", v))])
    error_message = "data_aws_security_groups, tags keys must be 1-128 characters and values must be 0-256 characters."
  }
}

variable "filter" {
  description = "One or more name/value pairs to use as filters. Check describe-security-groups in the AWS CLI reference for valid keys."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition     = alltrue([for f in var.filter : f.name != "" && length(f.values) > 0])
    error_message = "data_aws_security_groups, filter name must not be empty and values must contain at least one element."
  }

  validation {
    condition     = alltrue([for f in var.filter : alltrue([for v in f.values : v != ""])])
    error_message = "data_aws_security_groups, filter values must not contain empty strings."
  }
}

variable "read_timeout" {
  description = "Read timeout configuration for the data source."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.read_timeout))
    error_message = "data_aws_security_groups, read_timeout must be a valid duration format (e.g., 20m, 1h, 30s)."
  }
}