variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "definition" {
  description = "The Amazon States Language definition of the state machine."
  type        = string

  validation {
    condition     = can(jsonencode(jsondecode(var.definition)))
    error_message = "resource_aws_sfn_state_machine, definition must be valid JSON."
  }
}

variable "encryption_configuration" {
  description = "Defines what encryption configuration is used to encrypt data in the State Machine."
  type = object({
    kms_key_id                        = optional(string)
    type                              = string
    kms_data_key_reuse_period_seconds = optional(number)
  })
  default = null

  validation {
    condition = var.encryption_configuration == null || (
      var.encryption_configuration != null &&
      contains(["AWS_OWNED_KEY", "CUSTOMER_MANAGED_KMS_KEY"], var.encryption_configuration.type)
    )
    error_message = "resource_aws_sfn_state_machine, encryption_configuration.type must be either 'AWS_OWNED_KEY' or 'CUSTOMER_MANAGED_KMS_KEY'."
  }

  validation {
    condition = var.encryption_configuration == null || (
      var.encryption_configuration != null &&
      (var.encryption_configuration.type != "CUSTOMER_MANAGED_KMS_KEY" || var.encryption_configuration.kms_key_id != null)
    )
    error_message = "resource_aws_sfn_state_machine, encryption_configuration.kms_key_id is required when encryption_configuration.type is 'CUSTOMER_MANAGED_KMS_KEY'."
  }

  validation {
    condition = var.encryption_configuration == null || (
      var.encryption_configuration != null &&
      (var.encryption_configuration.kms_data_key_reuse_period_seconds == null || var.encryption_configuration.kms_data_key_reuse_period_seconds >= 60)
    )
    error_message = "resource_aws_sfn_state_machine, encryption_configuration.kms_data_key_reuse_period_seconds must be at least 60 seconds."
  }
}

variable "logging_configuration" {
  description = "Defines what execution history events are logged and where they are logged. Valid when type is set to STANDARD or EXPRESS."
  type = object({
    include_execution_data = optional(bool)
    level                  = optional(string)
    log_destination        = optional(string)
  })
  default = null

  validation {
    condition = var.logging_configuration == null || (
      var.logging_configuration != null &&
      (var.logging_configuration.level == null || contains(["ALL", "ERROR", "FATAL", "OFF"], var.logging_configuration.level))
    )
    error_message = "resource_aws_sfn_state_machine, logging_configuration.level must be one of 'ALL', 'ERROR', 'FATAL', or 'OFF'."
  }

  validation {
    condition = var.logging_configuration == null || (
      var.logging_configuration != null &&
      (var.logging_configuration.log_destination == null || can(regex(":.*\\*$", var.logging_configuration.log_destination)))
    )
    error_message = "resource_aws_sfn_state_machine, logging_configuration.log_destination ARN must end with ':*'."
  }
}

variable "name" {
  description = "The name of the state machine. Should only contain 0-9, A-Z, a-z, - and _. Conflicts with name_prefix."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || can(regex("^[0-9A-Za-z_-]+$", var.name))
    error_message = "resource_aws_sfn_state_machine, name should only contain 0-9, A-Z, a-z, - and _."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null

  validation {
    condition     = var.name_prefix == null || can(regex("^[0-9A-Za-z_-]+$", var.name_prefix))
    error_message = "resource_aws_sfn_state_machine, name_prefix should only contain 0-9, A-Z, a-z, - and _."
  }
}

variable "publish" {
  description = "Set to true to publish a version of the state machine during creation."
  type        = bool
  default     = false
}

variable "role_arn" {
  description = "The Amazon Resource Name (ARN) of the IAM role to use for this state machine."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/.+", var.role_arn))
    error_message = "resource_aws_sfn_state_machine, role_arn must be a valid IAM role ARN."
  }
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}

variable "tracing_configuration" {
  description = "Selects whether AWS X-Ray tracing is enabled."
  type = object({
    enabled = optional(bool)
  })
  default = null
}

variable "type" {
  description = "Determines whether a Standard or Express state machine is created. The default is STANDARD. You cannot update the type of a state machine once it has been created."
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "EXPRESS"], var.type)
    error_message = "resource_aws_sfn_state_machine, type must be either 'STANDARD' or 'EXPRESS'."
  }
}