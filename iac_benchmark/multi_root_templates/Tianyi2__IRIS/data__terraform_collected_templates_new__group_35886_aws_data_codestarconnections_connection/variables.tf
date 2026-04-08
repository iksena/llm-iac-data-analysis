variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "arn" {
  description = "CodeStar Connection ARN."
  type        = string
  default     = null

  validation {
    condition     = var.arn == null || can(regex("^arn:aws[a-zA-Z-]*:codestar-connections:[a-z0-9-]+:[0-9]{12}:connection/[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.arn))
    error_message = "data_aws_codestarconnections_connection, arn must be a valid CodeStar Connection ARN."
  }
}

variable "name" {
  description = "CodeStar Connection name."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || (length(var.name) >= 1 && length(var.name) <= 32)
    error_message = "data_aws_codestarconnections_connection, name must be between 1 and 32 characters in length."
  }

  validation {
    condition     = var.name == null || can(regex("^[a-zA-Z0-9][a-zA-Z0-9._-]*$", var.name))
    error_message = "data_aws_codestarconnections_connection, name must start with an alphanumeric character and can contain alphanumeric characters, periods, underscores, and hyphens."
  }
}