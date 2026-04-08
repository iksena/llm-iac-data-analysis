variable "name" {
  description = "Name of the control."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_auditmanager_control, name must not be empty."
  }
}

variable "control_mapping_sources" {
  description = "Data mapping sources."
  type = list(object({
    source_name          = string
    source_set_up_option = string
    source_type          = string
    region               = optional(string)
    source_description   = optional(string)
    source_frequency     = optional(string)
    troubleshooting_text = optional(string)
    source_keyword = optional(object({
      keyword_input_type = string
      keyword_value      = string
    }))
  }))

  validation {
    condition     = length(var.control_mapping_sources) > 0
    error_message = "resource_aws_auditmanager_control, control_mapping_sources must contain at least one element."
  }

  validation {
    condition = alltrue([
      for cms in var.control_mapping_sources :
      contains(["System_Controls_Mapping", "Procedural_Controls_Mapping"], cms.source_set_up_option)
    ])
    error_message = "resource_aws_auditmanager_control, source_set_up_option must be either 'System_Controls_Mapping' or 'Procedural_Controls_Mapping'."
  }

  validation {
    condition = alltrue([
      for cms in var.control_mapping_sources :
      cms.source_set_up_option == "Procedural_Controls_Mapping" ? cms.source_type == "MANUAL" :
      contains(["AWS_Cloudtrail", "AWS_Config", "AWS_Security_Hub", "AWS_API_Call"], cms.source_type)
    ])
    error_message = "resource_aws_auditmanager_control, source_type must be 'MANUAL' when source_set_up_option is 'Procedural_Controls_Mapping', or one of 'AWS_Cloudtrail', 'AWS_Config', 'AWS_Security_Hub', 'AWS_API_Call' when automated."
  }

  validation {
    condition = alltrue([
      for cms in var.control_mapping_sources :
      cms.source_frequency != null ? contains(["DAILY", "WEEKLY", "MONTHLY"], cms.source_frequency) : true
    ])
    error_message = "resource_aws_auditmanager_control, source_frequency must be one of 'DAILY', 'WEEKLY', or 'MONTHLY' when specified."
  }

  validation {
    condition = alltrue([
      for cms in var.control_mapping_sources :
      cms.source_keyword != null ? contains(["INPUT_TEXT", "SELECT_FROM_LIST", "UPLOAD_FILE"], cms.source_keyword.keyword_input_type) : true
    ])
    error_message = "resource_aws_auditmanager_control, keyword_input_type must be one of 'INPUT_TEXT', 'SELECT_FROM_LIST', or 'UPLOAD_FILE' when source_keyword is specified."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "action_plan_instructions" {
  description = "Recommended actions to carry out if the control isn't fulfilled."
  type        = string
  default     = null
}

variable "action_plan_title" {
  description = "Title of the action plan for remediating the control."
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the control."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the control."
  type        = map(string)
  default     = {}
}

variable "testing_information" {
  description = "Steps to follow to determine if the control is satisfied."
  type        = string
  default     = null
}