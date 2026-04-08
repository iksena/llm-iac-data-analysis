variable "display_name" {
  description = "The display name of the data protection settings."
  type        = string

  validation {
    condition     = length(var.display_name) > 0
    error_message = "resource_aws_workspacesweb_data_protection_settings, display_name must be a non-empty string."
  }
}

variable "additional_encryption_context" {
  description = "Additional encryption context for the data protection settings."
  type        = map(string)
  default     = null
}

variable "customer_managed_key" {
  description = "ARN of the customer managed KMS key."
  type        = string
  default     = null

  validation {
    condition     = var.customer_managed_key == null || can(regex("^arn:aws:kms:", var.customer_managed_key))
    error_message = "resource_aws_workspacesweb_data_protection_settings, customer_managed_key must be a valid KMS key ARN."
  }
}

variable "description" {
  description = "The description of the data protection settings."
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags assigned to the resource."
  type        = map(string)
  default     = {}
}

variable "inline_redaction_configuration" {
  description = "The inline redaction configuration of the data protection settings."
  type = object({
    global_confidence_level = optional(number)
    global_enforced_urls    = optional(list(string))
    global_exempt_urls      = optional(list(string))
    inline_redaction_patterns = optional(list(object({
      built_in_pattern_id = optional(string)
      confidence_level    = optional(number)
      enforced_urls       = optional(list(string))
      exempt_urls         = optional(list(string))
      custom_pattern = optional(object({
        pattern_name        = string
        pattern_regex       = string
        keyword_regex       = optional(string)
        pattern_description = optional(string)
      }))
      redaction_place_holder = object({
        redaction_place_holder_type = string
        redaction_place_holder_text = optional(string)
      })
    })))
  })
  default = null

  validation {
    condition = var.inline_redaction_configuration == null || (
      var.inline_redaction_configuration.global_confidence_level == null ||
      (var.inline_redaction_configuration.global_confidence_level >= 1 && var.inline_redaction_configuration.global_confidence_level <= 3)
    )
    error_message = "resource_aws_workspacesweb_data_protection_settings, global_confidence_level must be between 1 and 3."
  }

  validation {
    condition = var.inline_redaction_configuration == null || var.inline_redaction_configuration.inline_redaction_patterns == null || alltrue([
      for pattern in var.inline_redaction_configuration.inline_redaction_patterns :
      pattern.confidence_level == null || (pattern.confidence_level >= 1 && pattern.confidence_level <= 3)
    ])
    error_message = "resource_aws_workspacesweb_data_protection_settings, confidence_level for inline redaction patterns must be between 1 and 3."
  }

  validation {
    condition = var.inline_redaction_configuration == null || var.inline_redaction_configuration.inline_redaction_patterns == null || alltrue([
      for pattern in var.inline_redaction_configuration.inline_redaction_patterns :
      (pattern.built_in_pattern_id != null && pattern.custom_pattern == null) ||
      (pattern.built_in_pattern_id == null && pattern.custom_pattern != null)
    ])
    error_message = "resource_aws_workspacesweb_data_protection_settings, inline_redaction_pattern must have either built_in_pattern_id or custom_pattern, but not both."
  }

  validation {
    condition = var.inline_redaction_configuration == null || var.inline_redaction_configuration.inline_redaction_patterns == null || alltrue([
      for pattern in var.inline_redaction_configuration.inline_redaction_patterns :
      pattern.redaction_place_holder.redaction_place_holder_type == "CustomText"
    ])
    error_message = "resource_aws_workspacesweb_data_protection_settings, redaction_place_holder_type must be 'CustomText'."
  }

  validation {
    condition = var.inline_redaction_configuration == null || var.inline_redaction_configuration.inline_redaction_patterns == null || alltrue([
      for pattern in var.inline_redaction_configuration.inline_redaction_patterns :
      pattern.custom_pattern == null || (
        length(pattern.custom_pattern.pattern_name) > 0 &&
        length(pattern.custom_pattern.pattern_regex) > 0
      )
    ])
    error_message = "resource_aws_workspacesweb_data_protection_settings, custom_pattern pattern_name and pattern_regex are required."
  }
}