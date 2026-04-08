variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the connection to be created. The name must be unique in the calling AWS account. Changing name will create a new resource."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.name))
    error_message = "resource_aws_codeconnections_connection, name must contain only alphanumeric characters, periods, underscores, and hyphens."
  }

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 32
    error_message = "resource_aws_codeconnections_connection, name must be between 1 and 32 characters long."
  }
}

variable "provider_type" {
  description = "The name of the external provider where your third-party code repository is configured. Changing provider_type will create a new resource. Conflicts with host_arn."
  type        = string
  default     = null

  validation {
    condition = var.provider_type == null || contains([
      "Bitbucket",
      "GitHub",
      "GitHubEnterpriseServer",
      "GitLab",
      "GitLabSelfManaged"
    ], var.provider_type)
    error_message = "resource_aws_codeconnections_connection, provider_type must be one of: Bitbucket, GitHub, GitHubEnterpriseServer, GitLab, GitLabSelfManaged."
  }
}

variable "host_arn" {
  description = "The Amazon Resource Name (ARN) of the host associated with the connection. Conflicts with provider_type."
  type        = string
  default     = null

  validation {
    condition     = var.host_arn == null || can(regex("^arn:aws:codeconnections:[a-z0-9-]+:[0-9]{12}:host/[a-z0-9-]+$", var.host_arn))
    error_message = "resource_aws_codeconnections_connection, host_arn must be a valid ARN format for CodeConnections host."
  }
}

variable "tags" {
  description = "Map of key-value resource tags to associate with the resource."
  type        = map(string)
  default     = {}
}

# Validation for mutual exclusion of provider_type and host_arn
locals {
  provider_type_provided = var.provider_type != null
  host_arn_provided      = var.host_arn != null
  both_provided          = local.provider_type_provided && local.host_arn_provided
  neither_provided       = !local.provider_type_provided && !local.host_arn_provided
}

# Custom validation using check block (Terraform 1.5+)
check "provider_type_host_arn_conflict" {
  assert {
    condition     = !local.both_provided
    error_message = "resource_aws_codeconnections_connection, provider_type and host_arn are mutually exclusive. Only one can be specified."
  }
}

check "provider_type_or_host_arn_required" {
  assert {
    condition     = !local.neither_provided
    error_message = "resource_aws_codeconnections_connection, either provider_type or host_arn must be specified."
  }
}