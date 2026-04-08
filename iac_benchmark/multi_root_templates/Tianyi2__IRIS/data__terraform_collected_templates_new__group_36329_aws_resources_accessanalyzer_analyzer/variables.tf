variable "analyzer_name" {
  description = "Name of the Analyzer."
  type        = string

  validation {
    condition     = length(var.analyzer_name) > 0
    error_message = "resource_aws_accessanalyzer_analyzer, analyzer_name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "type" {
  description = "Type that represents the zone of trust or scope for the analyzer. Valid values are ACCOUNT, ACCOUNT_INTERNAL_ACCESS, ACCOUNT_UNUSED_ACCESS, ORGANIZATION, ORGANIZATION_INTERNAL_ACCESS, ORGANIZATION_UNUSED_ACCESS. Defaults to ACCOUNT."
  type        = string
  default     = "ACCOUNT"

  validation {
    condition = contains([
      "ACCOUNT",
      "ACCOUNT_INTERNAL_ACCESS",
      "ACCOUNT_UNUSED_ACCESS",
      "ORGANIZATION",
      "ORGANIZATION_INTERNAL_ACCESS",
      "ORGANIZATION_UNUSED_ACCESS"
    ], var.type)
    error_message = "resource_aws_accessanalyzer_analyzer, type must be one of: ACCOUNT, ACCOUNT_INTERNAL_ACCESS, ACCOUNT_UNUSED_ACCESS, ORGANIZATION, ORGANIZATION_INTERNAL_ACCESS, ORGANIZATION_UNUSED_ACCESS."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "configuration" {
  description = "A block that specifies the configuration of the analyzer."
  type = object({
    internal_access = optional(object({
      analysis_rule = optional(object({
        inclusion = optional(list(object({
          account_ids    = optional(list(string))
          resource_arns  = optional(list(string))
          resource_types = optional(list(string))
        })))
      }))
    }))
    unused_access = optional(object({
      unused_access_age = optional(number)
      analysis_rule = optional(object({
        exclusion = optional(list(object({
          account_ids   = optional(list(string))
          resource_tags = optional(list(map(string)))
        })))
      }))
    }))
  })
  default = null
}