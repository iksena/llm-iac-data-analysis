variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_ssm_parameters_by_path, region must be a valid AWS region identifier."
  }
}

variable "path" {
  description = "The hierarchy for the parameter. Hierarchies start with a forward slash (/). The hierarchy is the parameter name except the last part of the parameter. The last part of the parameter name can't be in the path. A parameter name hierarchy can have a maximum of 15 levels."
  type        = string

  validation {
    condition     = can(regex("^/", var.path))
    error_message = "data_aws_ssm_parameters_by_path, path must start with a forward slash (/)."
  }

  validation {
    condition     = length(split("/", var.path)) <= 16
    error_message = "data_aws_ssm_parameters_by_path, path hierarchy can have a maximum of 15 levels."
  }
}

variable "with_decryption" {
  description = "Whether to retrieve all parameters in the hierarchy, particularly those of SecureString type, with their value decrypted. Defaults to true."
  type        = bool
  default     = true

  validation {
    condition     = can(tobool(var.with_decryption))
    error_message = "data_aws_ssm_parameters_by_path, with_decryption must be a boolean value."
  }
}

variable "recursive" {
  description = "Whether to retrieve all parameters within the hierarchy. Defaults to false."
  type        = bool
  default     = false

  validation {
    condition     = can(tobool(var.recursive))
    error_message = "data_aws_ssm_parameters_by_path, recursive must be a boolean value."
  }
}