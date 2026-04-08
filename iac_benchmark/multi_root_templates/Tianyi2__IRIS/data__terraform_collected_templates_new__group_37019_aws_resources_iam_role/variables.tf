variable "assume_role_policy" {
  description = "Policy that grants an entity permission to assume the role"
  type        = string

  validation {
    condition     = can(jsondecode(var.assume_role_policy))
    error_message = "resource_aws_iam_role, assume_role_policy must be a valid JSON string."
  }
}

variable "description" {
  description = "Description of the role"
  type        = string
  default     = null
}

variable "force_detach_policies" {
  description = "Whether to force detaching any policies the role has before destroying it"
  type        = bool
  default     = false
}

variable "inline_policy" {
  description = "Configuration block defining an exclusive set of IAM inline policies associated with the IAM role"
  type = list(object({
    name   = string
    policy = string
  }))
  default = []

  validation {
    condition = alltrue([
      for policy in var.inline_policy : can(jsondecode(policy.policy))
    ])
    error_message = "resource_aws_iam_role, inline_policy policy must be a valid JSON string."
  }

  validation {
    condition = alltrue([
      for policy in var.inline_policy : length(policy.name) > 0
    ])
    error_message = "resource_aws_iam_role, inline_policy name must not be empty."
  }
}

variable "managed_policy_arns" {
  description = "Set of exclusive IAM managed policy ARNs to attach to the IAM role"
  type        = set(string)
  default     = null

  validation {
    condition = var.managed_policy_arns == null ? true : alltrue([
      for arn in var.managed_policy_arns : can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:policy/", arn))
    ])
    error_message = "resource_aws_iam_role, managed_policy_arns must be valid IAM policy ARNs."
  }
}

variable "max_session_duration" {
  description = "Maximum session duration (in seconds) that you want to set for the specified role"
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "resource_aws_iam_role, max_session_duration must be between 3600 (1 hour) and 43200 (12 hours) seconds."
  }
}

variable "name" {
  description = "Friendly name of the role"
  type        = string
  default     = null

  validation {
    condition = var.name == null ? true : (
      length(var.name) >= 1 &&
      length(var.name) <= 64 &&
      can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.name))
    )
    error_message = "resource_aws_iam_role, name must be 1-64 characters long and contain only alphanumeric characters plus +=,.@_- characters."
  }
}

variable "name_prefix" {
  description = "Creates a unique friendly name beginning with the specified prefix"
  type        = string
  default     = null

  validation {
    condition = var.name_prefix == null ? true : (
      length(var.name_prefix) >= 1 &&
      length(var.name_prefix) <= 32 &&
      can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.name_prefix))
    )
    error_message = "resource_aws_iam_role, name_prefix must be 1-32 characters long and contain only alphanumeric characters plus +=,.@_- characters."
  }
}

variable "path" {
  description = "Path to the role"
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/[a-zA-Z0-9+=,.@_-]*/$|^/$", var.path))
    error_message = "resource_aws_iam_role, path must begin and end with / and contain only alphanumeric characters plus +=,.@_- characters."
  }

  validation {
    condition     = length(var.path) <= 512
    error_message = "resource_aws_iam_role, path must be 512 characters or fewer."
  }
}

variable "permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the role"
  type        = string
  default     = null

  validation {
    condition     = var.permissions_boundary == null ? true : can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:policy/", var.permissions_boundary))
    error_message = "resource_aws_iam_role, permissions_boundary must be a valid IAM policy ARN."
  }
}

variable "tags" {
  description = "Key-value mapping of tags for the IAM role"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for key in keys(var.tags) : length(key) <= 128
    ])
    error_message = "resource_aws_iam_role, tags keys must be 128 characters or fewer."
  }

  validation {
    condition = alltrue([
      for value in values(var.tags) : length(value) <= 256
    ])
    error_message = "resource_aws_iam_role, tags values must be 256 characters or fewer."
  }
}