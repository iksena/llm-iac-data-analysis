variable "name" {
  description = "Name for an Amplify app"
  type        = string
}

variable "access_token" {
  description = "Personal access token for a third-party source control system for an Amplify app"
  type        = string
  default     = null
  sensitive   = true
}

variable "auto_branch_creation_config" {
  description = "Automated branch creation configuration for an Amplify app"
  type = object({
    basic_auth_credentials        = optional(string)
    build_spec                    = optional(string)
    enable_auto_build             = optional(bool)
    enable_basic_auth             = optional(bool)
    enable_performance_mode       = optional(bool)
    enable_pull_request_preview   = optional(bool)
    environment_variables         = optional(map(string))
    framework                     = optional(string)
    pull_request_environment_name = optional(string)
    stage                         = optional(string)
  })
  default = null

  validation {
    condition = var.auto_branch_creation_config == null || (
      var.auto_branch_creation_config.stage == null ||
      contains(["PRODUCTION", "BETA", "DEVELOPMENT", "EXPERIMENTAL", "PULL_REQUEST"], var.auto_branch_creation_config.stage)
    )
    error_message = "resource_aws_amplify_app, auto_branch_creation_config.stage must be one of: PRODUCTION, BETA, DEVELOPMENT, EXPERIMENTAL, PULL_REQUEST."
  }
}

variable "auto_branch_creation_patterns" {
  description = "Automated branch creation glob patterns for an Amplify app"
  type        = list(string)
  default     = null
}

variable "basic_auth_credentials" {
  description = "Credentials for basic authorization for an Amplify app"
  type        = string
  default     = null
  sensitive   = true
}

variable "build_spec" {
  description = "The build specification (build spec) for an Amplify app"
  type        = string
  default     = null
}

variable "cache_config" {
  description = "Cache configuration for the Amplify app"
  type = object({
    type = string
  })
  default = null

  validation {
    condition     = var.cache_config == null || contains(["AMPLIFY_MANAGED", "AMPLIFY_MANAGED_NO_COOKIES"], var.cache_config.type)
    error_message = "resource_aws_amplify_app, cache_config.type must be one of: AMPLIFY_MANAGED, AMPLIFY_MANAGED_NO_COOKIES."
  }
}

variable "compute_role_arn" {
  description = "AWS Identity and Access Management (IAM) SSR compute role for an Amplify app"
  type        = string
  default     = null
}

variable "custom_headers" {
  description = "The custom HTTP headers for an Amplify app"
  type        = string
  default     = null
}

variable "custom_rule" {
  description = "Custom rewrite and redirect rules for an Amplify app"
  type = list(object({
    condition = optional(string)
    source    = string
    status    = optional(string)
    target    = string
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.custom_rule : rule.status == null || contains(["200", "301", "302", "404", "404-200"], rule.status)
    ])
    error_message = "resource_aws_amplify_app, custom_rule.status must be one of: 200, 301, 302, 404, 404-200."
  }
}

variable "description" {
  description = "Description for an Amplify app"
  type        = string
  default     = null
}

variable "enable_auto_branch_creation" {
  description = "Enables automated branch creation for an Amplify app"
  type        = bool
  default     = null
}

variable "enable_basic_auth" {
  description = "Enables basic authorization for an Amplify app"
  type        = bool
  default     = null
}

variable "enable_branch_auto_build" {
  description = "Enables auto-building of branches for the Amplify App"
  type        = bool
  default     = null
}

variable "enable_branch_auto_deletion" {
  description = "Automatically disconnects a branch in the Amplify Console when you delete a branch from your Git repository"
  type        = bool
  default     = null
}

variable "environment_variables" {
  description = "Environment variables map for an Amplify app"
  type        = map(string)
  default     = null
}

variable "iam_service_role_arn" {
  description = "AWS Identity and Access Management (IAM) service role for an Amplify app"
  type        = string
  default     = null
}

variable "job_config" {
  description = "Used to configure the Amplify Application build instance compute type"
  type = object({
    build_compute_type = optional(string)
  })
  default = null

  validation {
    condition = var.job_config == null || (
      var.job_config.build_compute_type == null ||
      contains(["STANDARD_8GB", "LARGE_16GB", "XLARGE_72GB"], var.job_config.build_compute_type)
    )
    error_message = "resource_aws_amplify_app, job_config.build_compute_type must be one of: STANDARD_8GB, LARGE_16GB, XLARGE_72GB."
  }
}

variable "oauth_token" {
  description = "OAuth token for a third-party source control system for an Amplify app"
  type        = string
  default     = null
  sensitive   = true
}

variable "platform" {
  description = "Platform or framework for an Amplify app"
  type        = string
  default     = "WEB"

  validation {
    condition     = contains(["WEB", "WEB_COMPUTE"], var.platform)
    error_message = "resource_aws_amplify_app, platform must be one of: WEB, WEB_COMPUTE."
  }
}

variable "repository" {
  description = "Repository for an Amplify app"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value mapping of resource tags"
  type        = map(string)
  default     = null
}