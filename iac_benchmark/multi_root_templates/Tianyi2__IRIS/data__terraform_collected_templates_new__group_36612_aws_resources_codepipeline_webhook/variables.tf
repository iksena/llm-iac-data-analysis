variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the webhook"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_codepipeline_webhook, name must be a non-empty string."
  }
}

variable "authentication" {
  description = "The type of authentication to use"
  type        = string

  validation {
    condition     = contains(["IP", "GITHUB_HMAC", "UNAUTHENTICATED"], var.authentication)
    error_message = "resource_aws_codepipeline_webhook, authentication must be one of: IP, GITHUB_HMAC, or UNAUTHENTICATED."
  }
}

variable "authentication_configuration" {
  description = "Authentication configuration block"
  type = object({
    secret_token     = optional(string)
    allowed_ip_range = optional(string)
  })
  default = null

  validation {
    condition = var.authentication_configuration == null || (
      (var.authentication == "GITHUB_HMAC" && var.authentication_configuration.secret_token != null) ||
      (var.authentication == "IP" && var.authentication_configuration.allowed_ip_range != null) ||
      var.authentication == "UNAUTHENTICATED"
    )
    error_message = "resource_aws_codepipeline_webhook, authentication_configuration secret_token is required for GITHUB_HMAC authentication, allowed_ip_range is required for IP authentication."
  }
}

variable "filter" {
  description = "One or more filter blocks"
  type = list(object({
    json_path    = string
    match_equals = string
  }))

  validation {
    condition     = length(var.filter) > 0
    error_message = "resource_aws_codepipeline_webhook, filter must contain at least one filter block."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.json_path) > 0 && length(f.match_equals) > 0
    ])
    error_message = "resource_aws_codepipeline_webhook, filter json_path and match_equals must be non-empty strings."
  }
}

variable "target_action" {
  description = "The name of the action in a pipeline you want to connect to the webhook"
  type        = string

  validation {
    condition     = length(var.target_action) > 0
    error_message = "resource_aws_codepipeline_webhook, target_action must be a non-empty string."
  }
}

variable "target_pipeline" {
  description = "The name of the pipeline"
  type        = string

  validation {
    condition     = length(var.target_pipeline) > 0
    error_message = "resource_aws_codepipeline_webhook, target_pipeline must be a non-empty string."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}