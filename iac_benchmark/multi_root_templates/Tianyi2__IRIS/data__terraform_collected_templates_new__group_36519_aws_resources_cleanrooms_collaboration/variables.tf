variable "name" {
  type        = string
  description = "The name of the collaboration. Collaboration names do not need to be unique."
}

variable "description" {
  type        = string
  description = "A description for a collaboration."
}

variable "creator_member_abilities" {
  type        = list(string)
  description = "The list of member abilities for the creator of the collaboration."

  validation {
    condition = can([
      for ability in var.creator_member_abilities :
      contains(["CAN_QUERY", "CAN_RECEIVE_RESULTS"], ability)
    ])
    error_message = "resource_aws_cleanrooms_collaboration, creator_member_abilities must contain valid values. Valid values may be found in AWS documentation."
  }
}

variable "creator_display_name" {
  type        = string
  description = "The name for the member record for the collaboration creator."
}

variable "query_log_status" {
  type        = string
  description = "Determines if members of the collaboration can enable query logs within their own memberships."

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.query_log_status)
    error_message = "resource_aws_cleanrooms_collaboration, query_log_status must be either 'ENABLED' or 'DISABLED'."
  }
}

variable "analytics_engine" {
  type        = string
  description = "Analytics engine used by the collaboration. Valid values are CLEAN_ROOMS_SQL (deprecated) and SPARK."
  default     = null

  validation {
    condition     = var.analytics_engine == null || contains(["CLEAN_ROOMS_SQL", "SPARK"], var.analytics_engine)
    error_message = "resource_aws_cleanrooms_collaboration, analytics_engine must be either 'CLEAN_ROOMS_SQL' or 'SPARK'."
  }
}

variable "data_encryption_metadata" {
  type = object({
    allow_clear_text                            = bool
    allow_duplicates                            = bool
    allow_joins_on_columns_with_different_names = bool
    preserve_nulls                              = bool
  })
  description = "A collection of settings which determine how the c3r client will encrypt data for use within this collaboration."
  default     = null
}

variable "members" {
  type = list(object({
    account_id       = string
    display_name     = string
    member_abilities = list(string)
  }))
  description = "Additional members of the collaboration which will be invited to join the collaboration."
  default     = []

  validation {
    condition = alltrue([
      for member in var.members : can(tonumber(member.account_id))
    ])
    error_message = "resource_aws_cleanrooms_collaboration, members account_id must be a valid AWS account ID (numeric string)."
  }

  validation {
    condition = alltrue([
      for member in var.members : length(member.display_name) > 0
    ])
    error_message = "resource_aws_cleanrooms_collaboration, members display_name cannot be empty."
  }
}

variable "tags" {
  type        = map(string)
  description = "Key value pairs which tag the collaboration."
  default     = {}
}

variable "timeouts" {
  type = object({
    create = optional(string, "1m")
    update = optional(string, "1m")
    delete = optional(string, "1m")
  })
  description = "Configuration options for resource timeouts."
  default     = {}
}