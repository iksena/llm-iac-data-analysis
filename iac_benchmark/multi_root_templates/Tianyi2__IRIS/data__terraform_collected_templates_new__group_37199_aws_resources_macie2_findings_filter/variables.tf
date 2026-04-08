variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "finding_criteria" {
  description = "The criteria to use to filter findings."
  type = object({
    criterion = optional(list(object({
      field          = string
      eq_exact_match = optional(list(string))
      eq             = optional(list(string))
      neq            = optional(list(string))
      lt             = optional(string)
      lte            = optional(string)
      gt             = optional(string)
      gte            = optional(string)
    })))
  })

  validation {
    condition     = var.finding_criteria != null
    error_message = "resource_aws_macie2_findings_filter, finding_criteria is required."
  }
}

variable "name" {
  description = "A custom name for the filter. The name must contain at least 3 characters and can contain as many as 64 characters. Conflicts with name_prefix."
  type        = string
  default     = null

  validation {
    condition = var.name == null || (
      length(var.name) >= 3 && length(var.name) <= 64
    )
    error_message = "resource_aws_macie2_findings_filter, name must contain at least 3 characters and can contain as many as 64 characters."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null
}

variable "description" {
  description = "A custom description of the filter. The description can contain as many as 512 characters."
  type        = string
  default     = null

  validation {
    condition = var.description == null || (
      length(var.description) <= 512
    )
    error_message = "resource_aws_macie2_findings_filter, description can contain as many as 512 characters."
  }
}

variable "action" {
  description = "The action to perform on findings that meet the filter criteria (finding_criteria). Valid values are: ARCHIVE, suppress (automatically archive) the findings; and, NOOP, don't perform any action on the findings."
  type        = string

  validation {
    condition     = contains(["ARCHIVE", "NOOP"], var.action)
    error_message = "resource_aws_macie2_findings_filter, action must be one of: ARCHIVE, NOOP."
  }
}

variable "position" {
  description = "The position of the filter in the list of saved filters on the Amazon Macie console. This value also determines the order in which the filter is applied to findings, relative to other filters that are also applied to the findings."
  type        = number
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}