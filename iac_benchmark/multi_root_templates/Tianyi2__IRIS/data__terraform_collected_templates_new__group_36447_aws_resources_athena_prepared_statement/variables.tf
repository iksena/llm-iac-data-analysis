variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the prepared statement. Maximum length of 256."
  type        = string

  validation {
    condition     = can(regex("^.{1,256}$", var.name))
    error_message = "resource_aws_athena_prepared_statement, name must be between 1 and 256 characters."
  }
}

variable "workgroup" {
  description = "The name of the workgroup to which the prepared statement belongs."
  type        = string
}

variable "query_statement" {
  description = "The query string for the prepared statement."
  type        = string
}

variable "description" {
  description = "Brief explanation of prepared statement. Maximum length of 1024."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || can(regex("^.{0,1024}$", var.description))
    error_message = "resource_aws_athena_prepared_statement, description must be no more than 1024 characters."
  }
}

variable "timeouts_create" {
  description = "Timeout for creating the prepared statement."
  type        = string
  default     = "60m"
}

variable "timeouts_update" {
  description = "Timeout for updating the prepared statement."
  type        = string
  default     = "180m"
}

variable "timeouts_delete" {
  description = "Timeout for deleting the prepared statement."
  type        = string
  default     = "90m"
}