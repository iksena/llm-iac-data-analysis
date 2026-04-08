variable "duration_seconds" {
  description = "The number of seconds the vended session credentials are valid for. Defaults to 3600."
  type        = number
  default     = 3600

  validation {
    condition     = var.duration_seconds >= 900 && var.duration_seconds <= 43200
    error_message = "resource_aws_rolesanywhere_profile, duration_seconds must be between 900 and 43200 seconds."
  }
}

variable "enabled" {
  description = "Whether or not the Profile is enabled."
  type        = bool
  default     = true
}

variable "managed_policy_arns" {
  description = "A list of managed policy ARNs that apply to the vended session credentials."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for arn in var.managed_policy_arns :
      can(regex("^arn:aws:iam::[0-9]{12}:policy/.*", arn))
    ])
    error_message = "resource_aws_rolesanywhere_profile, managed_policy_arns must be valid IAM policy ARNs."
  }
}

variable "name" {
  description = "The name of the Profile."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 255
    error_message = "resource_aws_rolesanywhere_profile, name must be between 1 and 255 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,._-]+$", var.name))
    error_message = "resource_aws_rolesanywhere_profile, name can only contain alphanumeric characters and the following special characters: +=,._-"
  }
}

variable "require_instance_properties" {
  description = "Specifies whether instance properties are required in CreateSession requests with this profile."
  type        = bool
  default     = false
}

variable "role_arns" {
  description = "A list of IAM roles that this profile can assume."
  type        = list(string)

  validation {
    condition     = length(var.role_arns) > 0
    error_message = "resource_aws_rolesanywhere_profile, role_arns must contain at least one IAM role ARN."
  }

  validation {
    condition = alltrue([
      for arn in var.role_arns :
      can(regex("^arn:aws:iam::[0-9]{12}:role/.*", arn))
    ])
    error_message = "resource_aws_rolesanywhere_profile, role_arns must be valid IAM role ARNs."
  }
}

variable "session_policy" {
  description = "A session policy that applies to the trust boundary of the vended session credentials."
  type        = string
  default     = null

  validation {
    condition = var.session_policy == null || (
      can(jsondecode(var.session_policy)) &&
      length(var.session_policy) <= 2048
    )
    error_message = "resource_aws_rolesanywhere_profile, session_policy must be valid JSON and not exceed 2048 characters."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for key in keys(var.tags) :
      length(key) >= 1 && length(key) <= 128
    ])
    error_message = "resource_aws_rolesanywhere_profile, tags keys must be between 1 and 128 characters."
  }

  validation {
    condition = alltrue([
      for value in values(var.tags) :
      length(value) <= 256
    ])
    error_message = "resource_aws_rolesanywhere_profile, tags values must not exceed 256 characters."
  }
}