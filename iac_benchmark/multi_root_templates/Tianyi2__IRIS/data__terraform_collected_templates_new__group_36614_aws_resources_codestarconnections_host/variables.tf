variable "name" {
  description = "The name of the host to be created. The name must be unique in the calling AWS account."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_codestarconnections_host, name cannot be empty."
  }
}

variable "provider_endpoint" {
  description = "The endpoint of the infrastructure to be represented by the host after it is created."
  type        = string

  validation {
    condition     = can(regex("^https?://", var.provider_endpoint))
    error_message = "resource_aws_codestarconnections_host, provider_endpoint must be a valid URL starting with http:// or https://."
  }
}

variable "provider_type" {
  description = "The name of the external provider where your third-party code repository is configured."
  type        = string

  validation {
    condition     = contains(["GitHubEnterpriseServer", "GitLabSelfManagedServer", "BitbucketDataCenterServer"], var.provider_type)
    error_message = "resource_aws_codestarconnections_host, provider_type must be one of: GitHubEnterpriseServer, GitLabSelfManagedServer, BitbucketDataCenterServer."
  }
}

variable "vpc_configuration" {
  description = "The VPC configuration to be provisioned for the host. A VPC must be configured, and the infrastructure to be represented by the host must already be connected to the VPC."
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
      length(var.vpc_configuration.vpc_id) > 0
    )
    error_message = "resource_aws_codestarconnections_host, vpc_configuration requires security_group_ids, subnet_ids, and vpc_id to be non-empty when specified."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}