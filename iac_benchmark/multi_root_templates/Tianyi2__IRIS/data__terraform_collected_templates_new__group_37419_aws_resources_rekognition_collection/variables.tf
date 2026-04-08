variable "collection_id" {
  description = "The name of the collection"
  type        = string

  validation {
    condition     = length(var.collection_id) > 0 && length(var.collection_id) <= 255
    error_message = "resource_aws_rekognition_collection, collection_id must be between 1 and 255 characters long."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.\\-]+$", var.collection_id))
    error_message = "resource_aws_rekognition_collection, collection_id can only contain alphanumeric characters, periods, underscores, and hyphens."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags assigned to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "create_timeout" {
  description = "Timeout for create operations"
  type        = string
  default     = "2m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.create_timeout))
    error_message = "resource_aws_rekognition_collection, create_timeout must be a valid duration string (e.g., '2m', '30s', '1h')."
  }
}