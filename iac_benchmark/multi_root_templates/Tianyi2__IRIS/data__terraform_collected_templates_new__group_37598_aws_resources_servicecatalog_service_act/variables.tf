variable "name" {
  description = "(Required) Self-service action name."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_servicecatalog_service_action, name cannot be empty."
  }
}

variable "description" {
  description = "(Optional) Self-service action description."
  type        = string
  default     = null
}

variable "accept_language" {
  description = "(Optional) Language code. Valid values are `en` (English), `jp` (Japanese), and `zh` (Chinese). Default is `en`."
  type        = string
  default     = "en"

  validation {
    condition     = contains(["en", "jp", "zh"], var.accept_language)
    error_message = "resource_aws_servicecatalog_service_action, accept_language must be one of: en, jp, zh."
  }
}

variable "region" {
  description = "(Optional) Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "definition_name" {
  description = "(Required) Name of the SSM document. For example, `AWS-RestartEC2Instance`. If you are using a shared SSM document, you must provide the ARN instead of the name."
  type        = string

  validation {
    condition     = length(var.definition_name) > 0
    error_message = "resource_aws_servicecatalog_service_action, definition_name cannot be empty."
  }
}

variable "definition_version" {
  description = "(Required) SSM document version. For example, `1`."
  type        = string

  validation {
    condition     = length(var.definition_version) > 0
    error_message = "resource_aws_servicecatalog_service_action, definition_version cannot be empty."
  }
}

variable "definition_type" {
  description = "(Optional) Service action definition type. Valid value is `SSM_AUTOMATION`. Default is `SSM_AUTOMATION`."
  type        = string
  default     = "SSM_AUTOMATION"

  validation {
    condition     = var.definition_type == "SSM_AUTOMATION"
    error_message = "resource_aws_servicecatalog_service_action, definition_type must be SSM_AUTOMATION."
  }
}

variable "definition_assume_role" {
  description = "(Optional) ARN of the role that performs the self-service actions on your behalf. For example, `arn:aws:iam::12345678910:role/ActionRole`. To reuse the provisioned product launch role, set to `LAUNCH_ROLE`."
  type        = string
  default     = null
}

variable "definition_parameters" {
  description = "(Optional) List of parameters in JSON format. For example: `[{\"Name\":\"InstanceId\",\"Type\":\"TARGET\"}]` or `[{\"Name\":\"InstanceId\",\"Type\":\"TEXT_VALUE\"}]`."
  type        = string
  default     = null
}

variable "timeouts" {
  description = "Configuration options for resource operation timeouts."
  type = object({
    create = optional(string, "3m")
    read   = optional(string, "10m")
    update = optional(string, "3m")
    delete = optional(string, "3m")
  })
  default = null
}