variable "name" {
  description = "The name of the event data store"
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "billing_mode" {
  description = "The billing mode for the event data store"
  type        = string
  default     = "EXTENDABLE_RETENTION_PRICING"

  validation {
    condition     = contains(["EXTENDABLE_RETENTION_PRICING", "FIXED_RETENTION_PRICING"], var.billing_mode)
    error_message = "resource_aws_cloudtrail_event_data_store, billing_mode must be either 'EXTENDABLE_RETENTION_PRICING' or 'FIXED_RETENTION_PRICING'."
  }
}

variable "suspend" {
  description = "Specifies whether to stop ingesting new events into the event data store"
  type        = bool
  default     = null
}

variable "advanced_event_selectors" {
  description = "The advanced event selectors to use to select the events for the data store"
  type = list(object({
    name = optional(string)
    field_selectors = list(object({
      field           = string
      equals          = optional(list(string))
      not_equals      = optional(list(string))
      starts_with     = optional(list(string))
      not_starts_with = optional(list(string))
      ends_with       = optional(list(string))
      not_ends_with   = optional(list(string))
    }))
  }))
  default = []

  validation {
    condition = alltrue([
      for selector in var.advanced_event_selectors : alltrue([
        for field_selector in selector.field_selectors :
        contains(["readOnly", "eventSource", "eventName", "eventCategory", "resources.type", "resources.ARN"], field_selector.field)
      ])
    ])
    error_message = "resource_aws_cloudtrail_event_data_store, advanced_event_selectors field must be one of: readOnly, eventSource, eventName, eventCategory, resources.type, resources.ARN."
  }

  validation {
    condition = alltrue([
      for selector in var.advanced_event_selectors : alltrue([
        for field_selector in selector.field_selectors :
        field_selector.field != "readOnly" || (field_selector.equals != null && field_selector.not_equals == null && field_selector.starts_with == null && field_selector.not_starts_with == null && field_selector.ends_with == null && field_selector.not_ends_with == null)
      ])
    ])
    error_message = "resource_aws_cloudtrail_event_data_store, advanced_event_selectors readOnly field can only use equals operator."
  }

  validation {
    condition = alltrue([
      for selector in var.advanced_event_selectors : alltrue([
        for field_selector in selector.field_selectors :
        field_selector.field != "eventCategory" || (field_selector.equals != null && field_selector.not_equals == null && field_selector.starts_with == null && field_selector.not_starts_with == null && field_selector.ends_with == null && field_selector.not_ends_with == null)
      ])
    ])
    error_message = "resource_aws_cloudtrail_event_data_store, advanced_event_selectors eventCategory field can only use equals operator."
  }

  validation {
    condition = alltrue([
      for selector in var.advanced_event_selectors : alltrue([
        for field_selector in selector.field_selectors :
        field_selector.field != "resources.type" || (field_selector.equals != null && field_selector.not_equals == null && field_selector.starts_with == null && field_selector.not_starts_with == null && field_selector.ends_with == null && field_selector.not_ends_with == null)
      ])
    ])
    error_message = "resource_aws_cloudtrail_event_data_store, advanced_event_selectors resources.type field can only use equals operator."
  }
}

variable "multi_region_enabled" {
  description = "Specifies whether the event data store includes events from all regions, or only from the region in which the event data store is created"
  type        = bool
  default     = true
}

variable "organization_enabled" {
  description = "Specifies whether an event data store collects events logged for an organization in AWS Organizations"
  type        = bool
  default     = false
}

variable "retention_period" {
  description = "The retention period of the event data store, in days"
  type        = number
  default     = 2555

  validation {
    condition     = var.retention_period >= 1 && var.retention_period <= 2555
    error_message = "resource_aws_cloudtrail_event_data_store, retention_period must be between 1 and 2555 days."
  }
}

variable "kms_key_id" {
  description = "Specifies the AWS KMS key ID to use to encrypt the events delivered by CloudTrail"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "termination_protection_enabled" {
  description = "Specifies whether termination protection is enabled for the event data store"
  type        = bool
  default     = true
}