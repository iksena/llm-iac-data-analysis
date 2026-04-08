variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "database_name" {
  description = "The name of the Timestream database. Minimum length of 3. Maximum length of 256."
  type        = string

  validation {
    condition     = length(var.database_name) >= 3 && length(var.database_name) <= 256
    error_message = "data_aws_timestreamwrite_database, database_name must be between 3 and 256 characters in length."
  }
}