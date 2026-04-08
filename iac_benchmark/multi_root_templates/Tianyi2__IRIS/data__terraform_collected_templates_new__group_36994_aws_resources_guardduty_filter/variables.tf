variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "detector_id" {
  description = "ID of a GuardDuty detector, attached to your account."
  type        = string

  validation {
    condition     = length(var.detector_id) > 0
    error_message = "resource_aws_guardduty_filter, detector_id cannot be empty."
  }
}

variable "name" {
  description = "The name of your filter."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_guardduty_filter, name cannot be empty."
  }
}

variable "description" {
  description = "Description of the filter."
  type        = string
  default     = null
}

variable "rank" {
  description = "Specifies the position of the filter in the list of current filters. Also specifies the order in which this filter is applied to the findings."
  type        = number

  validation {
    condition     = var.rank > 0
    error_message = "resource_aws_guardduty_filter, rank must be greater than 0."
  }
}

variable "action" {
  description = "Specifies the action that is to be applied to the findings that match the filter. Can be one of ARCHIVE or NOOP."
  type        = string

  validation {
    condition     = contains(["ARCHIVE", "NOOP"], var.action)
    error_message = "resource_aws_guardduty_filter, action must be one of: ARCHIVE, NOOP."
  }
}

variable "tags" {
  description = "The tags that you want to add to the Filter resource. A tag consists of a key and a value."
  type        = map(string)
  default     = {}
}

variable "finding_criteria" {
  description = "Represents the criteria to be used in the filter for querying findings."
  type = object({
    criterion = list(object({
      field                 = string
      equals                = optional(list(string))
      not_equals            = optional(list(string))
      greater_than          = optional(string)
      greater_than_or_equal = optional(string)
      less_than             = optional(string)
      less_than_or_equal    = optional(string)
    }))
  })

  validation {
    condition     = length(var.finding_criteria.criterion) > 0
    error_message = "resource_aws_guardduty_filter, finding_criteria must contain at least one criterion."
  }

  validation {
    condition = alltrue([
      for criterion in var.finding_criteria.criterion : length(criterion.field) > 0
    ])
    error_message = "resource_aws_guardduty_filter, finding_criteria criterion field cannot be empty."
  }

  validation {
    condition = alltrue([
      for criterion in var.finding_criteria.criterion : (
        length(compact([
          criterion.equals != null ? "equals" : null,
          criterion.not_equals != null ? "not_equals" : null,
          criterion.greater_than != null ? "greater_than" : null,
          criterion.greater_than_or_equal != null ? "greater_than_or_equal" : null,
          criterion.less_than != null ? "less_than" : null,
          criterion.less_than_or_equal != null ? "less_than_or_equal" : null
        ])) > 0
      )
    ])
    error_message = "resource_aws_guardduty_filter, finding_criteria each criterion must have at least one comparison operator."
  }
}