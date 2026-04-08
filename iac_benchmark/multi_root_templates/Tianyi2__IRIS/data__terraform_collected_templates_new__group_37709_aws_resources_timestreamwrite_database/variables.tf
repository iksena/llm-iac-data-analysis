variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "database_name" {
  description = "The name of the Timestream database. Minimum length of 3. Maximum length of 64."
  type        = string

  validation {
    condition     = length(var.database_name) >= 3 && length(var.database_name) <= 64
    error_message = "resource_aws_timestreamwrite_database, database_name must be between 3 and 64 characters in length."
  }
}

variable "kms_key_id" {
  description = "The ARN (not Alias ARN) of the KMS key to be used to encrypt the data stored in the database. If the KMS key is not specified, the database will be encrypted with a Timestream managed KMS key located in your account."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to this resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}