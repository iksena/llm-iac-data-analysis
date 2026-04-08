variable "name" {
  description = "Desired name of the project"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_rekognition_project, name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "auto_update" {
  description = "Specify if automatic retraining should occur. Valid values are ENABLED or DISABLED. Must be set when feature is CONTENT_MODERATION, but do not set otherwise"
  type        = string
  default     = null

  validation {
    condition     = var.auto_update == null || contains(["ENABLED", "DISABLED"], var.auto_update)
    error_message = "resource_aws_rekognition_project, auto_update must be either ENABLED or DISABLED."
  }
}

variable "feature" {
  description = "Specify the feature being customized. Valid values are CONTENT_MODERATION or CUSTOM_LABELS. Defaults to CUSTOM_LABELS"
  type        = string
  default     = "CUSTOM_LABELS"

  validation {
    condition     = contains(["CONTENT_MODERATION", "CUSTOM_LABELS"], var.feature)
    error_message = "resource_aws_rekognition_project, feature must be either CONTENT_MODERATION or CUSTOM_LABELS."
  }
}

variable "tags" {
  description = "Map of tags assigned to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for resource timeouts"
  type = object({
    create = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default = {
    create = "10m"
    delete = "10m"
  }
}