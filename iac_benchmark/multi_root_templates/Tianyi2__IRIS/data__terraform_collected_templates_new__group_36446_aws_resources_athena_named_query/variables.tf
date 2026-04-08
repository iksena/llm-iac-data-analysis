variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "Plain language name for the query"
  type        = string

  validation {
    condition     = can(regex("^.{1,128}$", var.name))
    error_message = "resource_aws_athena_named_query, name must be between 1 and 128 characters."
  }
}

variable "workgroup" {
  description = "Workgroup to which the query belongs"
  type        = string
  default     = "primary"
}

variable "database" {
  description = "Database to which the query belongs"
  type        = string
}

variable "query" {
  description = "Text of the query itself. In other words, all query statements"
  type        = string
  default     = "SELECT 1"

  validation {
    condition     = length(var.query) >= 1 && length(var.query) <= 262144
    error_message = "resource_aws_athena_named_query, query must be between 1 and 262144 characters."
  }
}

variable "description" {
  description = "Brief explanation of the query"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || can(regex("^.{1,1024}$", var.description))
    error_message = "resource_aws_athena_named_query, description must be between 1 and 1024 characters when provided."
  }
}