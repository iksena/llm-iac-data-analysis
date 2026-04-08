variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "name" {
  type        = string
  description = "The name of the custom plugin."

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.name)) && length(var.name) > 0
    error_message = "resource_aws_mskconnect_custom_plugin, name must be a non-empty string containing only alphanumeric characters, hyphens, and underscores."
  }
}

variable "content_type" {
  type        = string
  description = "The type of the plugin file. Allowed values are ZIP and JAR."

  validation {
    condition     = contains(["ZIP", "JAR"], var.content_type)
    error_message = "resource_aws_mskconnect_custom_plugin, content_type must be either 'ZIP' or 'JAR'."
  }
}

variable "description" {
  type        = string
  description = "A summary description of the custom plugin."
  default     = null
}

variable "s3_bucket_arn" {
  type        = string
  description = "The Amazon Resource Name (ARN) of an S3 bucket."

  validation {
    condition     = can(regex("^arn:aws:s3:::[a-z0-9.-]+$", var.s3_bucket_arn))
    error_message = "resource_aws_mskconnect_custom_plugin, s3_bucket_arn must be a valid S3 bucket ARN."
  }
}

variable "s3_file_key" {
  type        = string
  description = "The file key for an object in an S3 bucket."

  validation {
    condition     = length(var.s3_file_key) > 0
    error_message = "resource_aws_mskconnect_custom_plugin, s3_file_key must be a non-empty string."
  }
}

variable "s3_object_version" {
  type        = string
  description = "The version of an object in an S3 bucket."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource."
  default     = {}
}

variable "create_timeout" {
  type        = string
  description = "Timeout for creating the custom plugin."
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[mh]$", var.create_timeout))
    error_message = "resource_aws_mskconnect_custom_plugin, create_timeout must be a valid timeout format (e.g., '10m', '1h')."
  }
}

variable "delete_timeout" {
  type        = string
  description = "Timeout for deleting the custom plugin."
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[mh]$", var.delete_timeout))
    error_message = "resource_aws_mskconnect_custom_plugin, delete_timeout must be a valid timeout format (e.g., '10m', '1h')."
  }
}