variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The display name of a resource selection document."
  type        = string
  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_backup_selection, name must not be empty."
  }
}

variable "plan_id" {
  description = "The backup plan ID to be associated with the selection of resources."
  type        = string
  validation {
    condition     = length(var.plan_id) > 0
    error_message = "resource_aws_backup_selection, plan_id must not be empty."
  }
}

variable "iam_role_arn" {
  description = "The ARN of the IAM role that AWS Backup uses to authenticate when restoring and backing up the target resource."
  type        = string
  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.iam_role_arn))
    error_message = "resource_aws_backup_selection, iam_role_arn must be a valid IAM role ARN."
  }
}

variable "selection_tag" {
  description = "Tag-based conditions used to specify a set of resources to assign to a backup plan."
  type = object({
    type  = string
    key   = string
    value = string
  })
  default = null
  validation {
    condition = var.selection_tag == null || (
      contains(["STRINGEQUALS"], var.selection_tag.type) &&
      length(var.selection_tag.key) > 0 &&
      length(var.selection_tag.value) > 0
    )
    error_message = "resource_aws_backup_selection, selection_tag type must be STRINGEQUALS and key/value must not be empty."
  }
}

variable "condition" {
  description = "Condition-based filters used to specify sets of resources for a backup plan."
  type = object({
    string_equals = optional(object({
      key   = string
      value = string
    }))
    string_not_equals = optional(object({
      key   = string
      value = string
    }))
    string_like = optional(object({
      key   = string
      value = string
    }))
    string_not_like = optional(object({
      key   = string
      value = string
    }))
  })
  default = null
  validation {
    condition = var.condition == null || (
      (var.condition.string_equals == null || (length(var.condition.string_equals.key) > 0 && length(var.condition.string_equals.value) > 0)) &&
      (var.condition.string_not_equals == null || (length(var.condition.string_not_equals.key) > 0 && length(var.condition.string_not_equals.value) > 0)) &&
      (var.condition.string_like == null || (length(var.condition.string_like.key) > 0 && length(var.condition.string_like.value) > 0)) &&
      (var.condition.string_not_like == null || (length(var.condition.string_not_like.key) > 0 && length(var.condition.string_not_like.value) > 0))
    )
    error_message = "resource_aws_backup_selection, condition key and value must not be empty for any specified condition type."
  }
}

variable "resources" {
  description = "An array of strings that either contain Amazon Resource Names (ARNs) or match patterns of resources to assign to a backup plan."
  type        = list(string)
  default     = null
  validation {
    condition = var.resources == null || (
      length(var.resources) > 0 &&
      alltrue([for r in var.resources : length(r) > 0])
    )
    error_message = "resource_aws_backup_selection, resources must not be empty and all resource entries must not be empty."
  }
}

variable "not_resources" {
  description = "An array of strings that either contain Amazon Resource Names (ARNs) or match patterns of resources to exclude from a backup plan."
  type        = list(string)
  default     = null
  validation {
    condition = var.not_resources == null || (
      length(var.not_resources) > 0 &&
      alltrue([for r in var.not_resources : length(r) > 0])
    )
    error_message = "resource_aws_backup_selection, not_resources must not be empty and all resource entries must not be empty."
  }
}