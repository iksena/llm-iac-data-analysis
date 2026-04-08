variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "app_id" {
  description = "Unique ID for an Amplify app."
  type        = string

  validation {
    condition     = length(var.app_id) > 0
    error_message = "resource_aws_amplify_branch, app_id must not be empty."
  }
}

variable "branch_name" {
  description = "Name for the branch."
  type        = string

  validation {
    condition     = length(var.branch_name) > 0
    error_message = "resource_aws_amplify_branch, branch_name must not be empty."
  }
}

variable "backend_environment_arn" {
  description = "ARN for a backend environment that is part of an Amplify app."
  type        = string
  default     = null
}

variable "basic_auth_credentials" {
  description = "Basic authorization credentials for the branch."
  type        = string
  default     = null
  sensitive   = true
}

variable "description" {
  description = "Description for the branch."
  type        = string
  default     = null
}

variable "display_name" {
  description = "Display name for a branch. This is used as the default domain prefix."
  type        = string
  default     = null
}

variable "enable_auto_build" {
  description = "Enables auto building for the branch."
  type        = bool
  default     = null
}

variable "enable_basic_auth" {
  description = "Enables basic authorization for the branch."
  type        = bool
  default     = null
}

variable "enable_notification" {
  description = "Enables notifications for the branch."
  type        = bool
  default     = null
}

variable "enable_performance_mode" {
  description = "Enables performance mode for the branch."
  type        = bool
  default     = null
}

variable "enable_pull_request_preview" {
  description = "Enables pull request previews for this branch."
  type        = bool
  default     = null
}

variable "enable_skew_protection" {
  description = "Enables skew protection for the branch."
  type        = bool
  default     = null
}

variable "environment_variables" {
  description = "Environment variables for the branch."
  type        = map(string)
  default     = null
}

variable "framework" {
  description = "Framework for the branch."
  type        = string
  default     = null
}

variable "pull_request_environment_name" {
  description = "Amplify environment name for the pull request."
  type        = string
  default     = null
}

variable "stage" {
  description = "Describes the current stage for the branch."
  type        = string
  default     = null

  validation {
    condition     = var.stage == null || contains(["PRODUCTION", "BETA", "DEVELOPMENT", "EXPERIMENTAL", "PULL_REQUEST"], var.stage)
    error_message = "resource_aws_amplify_branch, stage must be one of: PRODUCTION, BETA, DEVELOPMENT, EXPERIMENTAL, PULL_REQUEST."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags."
  type        = map(string)
  default     = {}
}

variable "ttl" {
  description = "Content Time To Live (TTL) for the website in seconds."
  type        = number
  default     = null

  validation {
    condition     = var.ttl == null || var.ttl > 0
    error_message = "resource_aws_amplify_branch, ttl must be a positive number."
  }
}