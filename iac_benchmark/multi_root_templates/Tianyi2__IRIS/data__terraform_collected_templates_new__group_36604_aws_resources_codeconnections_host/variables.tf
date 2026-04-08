variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the host to be created. The name must be unique in the calling AWS account"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.name))
    error_message = "resource_aws_codeconnections_host, name must contain only alphanumeric characters, periods, underscores, and hyphens."
  }
}

variable "provider_endpoint" {
  description = "The endpoint of the infrastructure to be represented by the host after it is created"
  type        = string

  validation {
    condition     = can(regex("^https://", var.provider_endpoint))
    error_message = "resource_aws_codeconnections_host, provider_endpoint must be a valid HTTPS URL."
  }
}

variable "provider_type" {
  description = "The name of the external provider where your third-party code repository is configured"
  type        = string

  validation {
    condition = contains([
      "GitHub",
      "GitHubEnterpriseServer",
      "GitLab",
      "GitLabEnterpriseServer",
      "Bitbucket"
    ], var.provider_type)
    error_message = "resource_aws_codeconnections_host, provider_type must be one of: GitHub, GitHubEnterpriseServer, GitLab, GitLabEnterpriseServer, Bitbucket."
  }
}

variable "vpc_configuration" {
  description = "The VPC configuration to be provisioned for the host"
  type = object({
    security_group_ids = list(string)
    subnet_ids         = list(string)
    tls_certificate    = optional(string)
    vpc_id             = string
  })
  default = null

  validation {
    condition = var.vpc_configuration == null || (
      length(var.vpc_configuration.security_group_ids) > 0 &&
      length(var.vpc_configuration.subnet_ids) > 0 &&
      var.vpc_configuration.vpc_id != ""
    )
    error_message = "resource_aws_codeconnections_host, vpc_configuration when specified, security_group_ids and subnet_ids must not be empty and vpc_id must be provided."
  }

  validation {
    condition = var.vpc_configuration == null || alltrue([
      for sg_id in var.vpc_configuration.security_group_ids : can(regex("^sg-[0-9a-f]{8,17}$", sg_id))
    ])
    error_message = "resource_aws_codeconnections_host, vpc_configuration security_group_ids must be valid security group IDs (sg-xxxxxxxx)."
  }

  validation {
    condition = var.vpc_configuration == null || alltrue([
      for subnet_id in var.vpc_configuration.subnet_ids : can(regex("^subnet-[0-9a-f]{8,17}$", subnet_id))
    ])
    error_message = "resource_aws_codeconnections_host, vpc_configuration subnet_ids must be valid subnet IDs (subnet-xxxxxxxx)."
  }

  validation {
    condition     = var.vpc_configuration == null || can(regex("^vpc-[0-9a-f]{8,17}$", var.vpc_configuration.vpc_id))
    error_message = "resource_aws_codeconnections_host, vpc_configuration vpc_id must be a valid VPC ID (vpc-xxxxxxxx)."
  }
}