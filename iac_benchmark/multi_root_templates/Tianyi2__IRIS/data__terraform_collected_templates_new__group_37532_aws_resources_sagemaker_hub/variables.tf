variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "hub_name" {
  description = "The name of the hub."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\-]{1,63}$", var.hub_name))
    error_message = "resource_aws_sagemaker_hub, hub_name must be 1-63 characters long and contain only alphanumeric characters and hyphens."
  }
}

variable "hub_description" {
  description = "A description of the hub."
  type        = string

  validation {
    condition     = length(var.hub_description) > 0 && length(var.hub_description) <= 1024
    error_message = "resource_aws_sagemaker_hub, hub_description must be between 1 and 1024 characters long."
  }
}

variable "hub_display_name" {
  description = "The display name of the hub."
  type        = string
  default     = null

  validation {
    condition     = var.hub_display_name == null || (length(var.hub_display_name) > 0 && length(var.hub_display_name) <= 255)
    error_message = "resource_aws_sagemaker_hub, hub_display_name must be between 1 and 255 characters long when specified."
  }
}

variable "hub_search_keywords" {
  description = "The searchable keywords for the hub."
  type        = list(string)
  default     = null

  validation {
    condition     = var.hub_search_keywords == null || length(var.hub_search_keywords) <= 50
    error_message = "resource_aws_sagemaker_hub, hub_search_keywords cannot contain more than 50 keywords."
  }
}

variable "s3_storage_config" {
  description = "The Amazon S3 storage configuration for the hub."
  type = object({
    s3_output_path = optional(string)
  })
  default = null

  validation {
    condition = var.s3_storage_config == null || (
      var.s3_storage_config.s3_output_path == null ||
      can(regex("^s3://[a-z0-9][a-z0-9\\-]*[a-z0-9](/.*)?$", var.s3_storage_config.s3_output_path))
    )
    error_message = "resource_aws_sagemaker_hub, s3_output_path must be a valid S3 URI starting with s3:// when specified."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}

  validation {
    condition     = length(var.tags) <= 50
    error_message = "resource_aws_sagemaker_hub, tags cannot contain more than 50 key-value pairs."
  }
}