variable "name" {
  description = "The plain language name for the query. Maximum length of 128."
  type        = string

  validation {
    condition     = length(var.name) <= 128
    error_message = "data_aws_athena_named_query, name must be 128 characters or less."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "workgroup" {
  description = "The workgroup to which the query belongs. Defaults to primary."
  type        = string
  default     = "primary"
}