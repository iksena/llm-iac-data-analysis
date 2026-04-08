variable "index_id" {
  description = "The identifier of the index for your Amazon Kendra experience."
  type        = string

  validation {
    condition     = length(var.index_id) > 0
    error_message = "resource_aws_kendra_experience, index_id must be a non-empty string."
  }
}

variable "name" {
  description = "A name for your Amazon Kendra experience."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_kendra_experience, name must be a non-empty string."
  }
}

variable "role_arn" {
  description = "The Amazon Resource Name (ARN) of a role with permission to access Query API, QuerySuggestions API, SubmitFeedback API, and AWS SSO that stores your user and group information."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/.+", var.role_arn))
    error_message = "resource_aws_kendra_experience, role_arn must be a valid IAM role ARN."
  }
}

variable "description" {
  description = "A description for your Amazon Kendra experience."
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed."
  type        = string
  default     = null
}

variable "configuration" {
  description = "Configuration information for your Amazon Kendra experience."
  type = object({
    content_source_configuration = optional(object({
      data_source_ids    = optional(list(string))
      direct_put_content = optional(bool)
      faq_ids            = optional(list(string))
    }))
    user_identity_configuration = optional(object({
      identity_attribute_name = string
    }))
  })
  default = null

  validation {
    condition = var.configuration == null || (
      var.configuration.content_source_configuration != null ||
      var.configuration.user_identity_configuration != null
    )
    error_message = "resource_aws_kendra_experience, configuration must have either content_source_configuration or user_identity_configuration specified."
  }

  validation {
    condition = var.configuration == null || var.configuration.content_source_configuration == null || (
      var.configuration.content_source_configuration.data_source_ids == null ||
      length(var.configuration.content_source_configuration.data_source_ids) <= 100
    )
    error_message = "resource_aws_kendra_experience, configuration.content_source_configuration.data_source_ids maximum number of 100 items allowed."
  }

  validation {
    condition = var.configuration == null || var.configuration.content_source_configuration == null || (
      var.configuration.content_source_configuration.faq_ids == null ||
      length(var.configuration.content_source_configuration.faq_ids) <= 100
    )
    error_message = "resource_aws_kendra_experience, configuration.content_source_configuration.faq_ids maximum number of 100 items allowed."
  }

  validation {
    condition = var.configuration == null || var.configuration.user_identity_configuration == null || (
      length(var.configuration.user_identity_configuration.identity_attribute_name) > 0
    )
    error_message = "resource_aws_kendra_experience, configuration.user_identity_configuration.identity_attribute_name must be a non-empty string."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.create))
    error_message = "resource_aws_kendra_experience, timeouts.create must be a valid duration (e.g., '30m', '1h')."
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.update))
    error_message = "resource_aws_kendra_experience, timeouts.update must be a valid duration (e.g., '30m', '1h')."
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    error_message = "resource_aws_kendra_experience, timeouts.delete must be a valid duration (e.g., '30m', '1h')."
  }
}