variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "project_name" {
  description = "The name of the build project."
  type        = string

  validation {
    condition     = length(var.project_name) > 0
    error_message = "resource_aws_codebuild_webhook, project_name cannot be empty."
  }
}

variable "build_type" {
  description = "The type of build this webhook will trigger. Valid values: BUILD, BUILD_BATCH."
  type        = string
  default     = null

  validation {
    condition     = var.build_type == null || contains(["BUILD", "BUILD_BATCH"], var.build_type)
    error_message = "resource_aws_codebuild_webhook, build_type must be one of: BUILD, BUILD_BATCH."
  }
}

variable "manual_creation" {
  description = "If true, CodeBuild doesn't create a webhook in GitHub and instead returns payload_url and secret values for the webhook."
  type        = bool
  default     = null
}

variable "branch_filter" {
  description = "A regular expression used to determine which branches get built. Default is all branches are built."
  type        = string
  default     = null
}

variable "filter_group" {
  description = "Information about the webhook's trigger. Filter group blocks."
  type = list(object({
    filter = list(object({
      type                    = string
      pattern                 = string
      exclude_matched_pattern = optional(bool, false)
    }))
  }))
  default = []

  validation {
    condition = alltrue([
      for group in var.filter_group : alltrue([
        for filter in group.filter : contains([
          "EVENT", "BASE_REF", "HEAD_REF", "ACTOR_ACCOUNT_ID",
          "FILE_PATH", "COMMIT_MESSAGE", "WORKFLOW_NAME", "TAG_NAME", "RELEASE_NAME"
        ], filter.type)
      ])
    ])
    error_message = "resource_aws_codebuild_webhook, filter_group filter type must be one of: EVENT, BASE_REF, HEAD_REF, ACTOR_ACCOUNT_ID, FILE_PATH, COMMIT_MESSAGE, WORKFLOW_NAME, TAG_NAME, RELEASE_NAME."
  }

  validation {
    condition = alltrue([
      for group in var.filter_group : alltrue([
        for filter in group.filter : length(filter.pattern) > 0
      ])
    ])
    error_message = "resource_aws_codebuild_webhook, filter_group filter pattern cannot be empty."
  }

  validation {
    condition = length(var.filter_group) == 0 || anytrue([
      for group in var.filter_group : anytrue([
        for filter in group.filter : filter.type == "EVENT"
      ])
    ])
    error_message = "resource_aws_codebuild_webhook, filter_group at least one filter group must specify EVENT as its type."
  }
}

variable "scope_configuration" {
  description = "Scope configuration for global or organization webhooks."
  type = object({
    name   = string
    scope  = string
    domain = optional(string)
  })
  default = null

  validation {
    condition     = var.scope_configuration == null || length(var.scope_configuration.name) > 0
    error_message = "resource_aws_codebuild_webhook, scope_configuration name cannot be empty."
  }

  validation {
    condition     = var.scope_configuration == null || contains(["GITHUB_ORGANIZATION", "GITHUB_GLOBAL"], var.scope_configuration.scope)
    error_message = "resource_aws_codebuild_webhook, scope_configuration scope must be one of: GITHUB_ORGANIZATION, GITHUB_GLOBAL."
  }
}

variable "pull_request_build_policy" {
  description = "Defines comment-based approval requirements for triggering builds on pull requests."
  type = object({
    requires_comment_approval = string
    approver_roles           = optional(list(string))
  })
  default = null

  validation {
    condition     = var.pull_request_build_policy == null || contains(["DISABLED", "ALL_PULL_REQUESTS", "FORK_PULL_REQUESTS"], var.pull_request_build_policy.requires_comment_approval)
    error_message = "resource_aws_codebuild_webhook, pull_request_build_policy requires_comment_approval must be one of: DISABLED, ALL_PULL_REQUESTS, FORK_PULL_REQUESTS."
  }

  validation {
    condition = var.pull_request_build_policy == null || (
      var.pull_request_build_policy.requires_comment_approval == "DISABLED" || 
      var.pull_request_build_policy.approver_roles != null
    )
    error_message = "resource_aws_codebuild_webhook, pull_request_build_policy approver_roles must be specified when requires_comment_approval is not DISABLED."
  }
}