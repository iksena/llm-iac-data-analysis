variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "catalog_id" {
  description = "ID of the Data Catalog to create the tag in. If omitted, this defaults to the AWS Account ID."
  type        = string
  default     = null
}

variable "key" {
  description = "Key-name for the tag."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]+$", var.key))
    error_message = "resource_aws_lakeformation_lf_tag, key must contain only alphanumeric characters, underscores, periods, and hyphens."
  }
}

variable "values" {
  description = "List of possible values an attribute can take. Maximum number of values permitted is 1000."
  type        = list(string)

  validation {
    condition     = length(var.values) > 0
    error_message = "resource_aws_lakeformation_lf_tag, values must have at least one value."
  }

  validation {
    condition     = length(var.values) <= 1000
    error_message = "resource_aws_lakeformation_lf_tag, values cannot exceed 1000 values."
  }
}