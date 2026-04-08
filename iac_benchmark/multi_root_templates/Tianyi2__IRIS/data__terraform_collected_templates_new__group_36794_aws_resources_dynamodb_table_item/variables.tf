variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "hash_key" {
  description = "Hash key to use for lookups and identification of the item"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]+$", var.hash_key))
    error_message = "resource_aws_dynamodb_table_item, hash_key must contain only alphanumeric characters, underscores, periods, and hyphens."
  }
}

variable "item" {
  description = "JSON representation of a map of attribute name/value pairs, one for each attribute. Only the primary key attributes are required; you can optionally provide other attribute name-value pairs for the item."
  type        = string

  validation {
    condition     = can(jsondecode(var.item))
    error_message = "resource_aws_dynamodb_table_item, item must be a valid JSON string."
  }
}

variable "range_key" {
  description = "Range key to use for lookups and identification of the item. Required if there is range key defined in the table."
  type        = string
  default     = null

  validation {
    condition     = var.range_key == null || can(regex("^[a-zA-Z0-9_.-]+$", var.range_key))
    error_message = "resource_aws_dynamodb_table_item, range_key must contain only alphanumeric characters, underscores, periods, and hyphens."
  }
}

variable "table_name" {
  description = "Name of the table to contain the item."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]+$", var.table_name))
    error_message = "resource_aws_dynamodb_table_item, table_name must contain only alphanumeric characters, underscores, periods, and hyphens."
  }

  validation {
    condition     = length(var.table_name) >= 3 && length(var.table_name) <= 255
    error_message = "resource_aws_dynamodb_table_item, table_name must be between 3 and 255 characters long."
  }
}