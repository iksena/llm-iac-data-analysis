variable "name" {
  description = "Name of the framework"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_auditmanager_framework, name must not be empty."
  }
}

variable "control_sets" {
  description = "Configuration block(s) for the control sets that are associated with the framework"
  type = list(object({
    name = string
    controls = list(object({
      id = string
    }))
  }))

  validation {
    condition     = length(var.control_sets) > 0
    error_message = "resource_aws_auditmanager_framework, control_sets must contain at least one control set."
  }

  validation {
    condition = alltrue([
      for cs in var.control_sets : length(cs.name) > 0
    ])
    error_message = "resource_aws_auditmanager_framework, control_sets name must not be empty."
  }

  validation {
    condition = alltrue([
      for cs in var.control_sets : length(cs.controls) > 0
    ])
    error_message = "resource_aws_auditmanager_framework, control_sets controls must contain at least one control."
  }

  validation {
    condition = alltrue(flatten([
      for cs in var.control_sets : [
        for c in cs.controls : length(c.id) > 0
      ]
    ]))
    error_message = "resource_aws_auditmanager_framework, control_sets controls id must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "compliance_type" {
  description = "Compliance type that the new custom framework supports, such as CIS or HIPAA"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the framework"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the framework"
  type        = map(string)
  default     = {}
}