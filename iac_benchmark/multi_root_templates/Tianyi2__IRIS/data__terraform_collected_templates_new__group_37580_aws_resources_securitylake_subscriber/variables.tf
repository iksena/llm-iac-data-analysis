variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "access_type" {
  description = "The Amazon S3 or Lake Formation access type"
  type        = string
  default     = null
}

variable "source" {
  description = "The supported AWS services from which logs and events are collected"
  type = list(object({
    aws_log_source_resource = optional(object({
      source_name    = string
      source_version = optional(string)
    }))
    custom_log_source_resource = optional(object({
      source_name    = string
      source_version = optional(string)
    }))
  }))

  validation {
    condition     = length(var.source) > 0
    error_message = "resource_aws_securitylake_subscriber, source must contain at least one source block."
  }

  validation {
    condition = alltrue([
      for s in var.source : (
        (s.aws_log_source_resource != null ? 1 : 0) +
        (s.custom_log_source_resource != null ? 1 : 0)
      ) == 1
    ])
    error_message = "resource_aws_securitylake_subscriber, source must contain exactly one of aws_log_source_resource or custom_log_source_resource."
  }

  validation {
    condition = alltrue([
      for s in var.source : 
        s.aws_log_source_resource == null || 
        contains(["ROUTE53", "VPC_FLOW", "SH_FINDINGS", "CLOUD_TRAIL_MGMT", "LAMBDA_EXECUTION", "S3_DATA", "EKS_AUDIT", "WAF"], s.aws_log_source_resource.source_name)
    ])
    error_message = "resource_aws_securitylake_subscriber, aws_log_source_resource.source_name must be one of: ROUTE53, VPC_FLOW, SH_FINDINGS, CLOUD_TRAIL_MGMT, LAMBDA_EXECUTION, S3_DATA, EKS_AUDIT, WAF."
  }
}

variable "subscriber_identity" {
  description = "The AWS identity used to access your data"
  type = object({
    external_id = string
    principal   = string
  })

  validation {
    condition     = var.subscriber_identity.external_id != null && var.subscriber_identity.external_id != ""
    error_message = "resource_aws_securitylake_subscriber, subscriber_identity.external_id is required and cannot be empty."
  }

  validation {
    condition     = var.subscriber_identity.principal != null && var.subscriber_identity.principal != ""
    error_message = "resource_aws_securitylake_subscriber, subscriber_identity.principal is required and cannot be empty."
  }
}

variable "subscriber_description" {
  description = "The description for your subscriber account in Security Lake"
  type        = string
  default     = null
}

variable "subscriber_name" {
  description = "The name of your Security Lake subscriber account"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "60m")
    update = optional(string, "180m")
    delete = optional(string, "90m")
  })
  default = {
    create = "60m"
    update = "180m"
    delete = "90m"
  }
}