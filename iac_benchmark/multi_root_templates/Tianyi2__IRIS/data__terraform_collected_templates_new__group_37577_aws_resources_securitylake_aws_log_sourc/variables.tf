variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "source_accounts" {
  description = "Specify the AWS account information where you want to enable Security Lake. If not specified, uses all accounts included in the Security Lake."
  type        = list(string)
  default     = null

  validation {
    condition = var.source_accounts == null ? true : alltrue([
      for account in var.source_accounts : can(regex("^[0-9]{12}$", account))
    ])
    error_message = "resource_aws_securitylake_aws_log_source, source_accounts must be a list of 12-digit AWS account IDs."
  }
}

variable "source_regions" {
  description = "Specify the Regions where you want to enable Security Lake."
  type        = list(string)

  validation {
    condition     = var.source_regions != null && length(var.source_regions) > 0
    error_message = "resource_aws_securitylake_aws_log_source, source_regions is required and must contain at least one region."
  }

  validation {
    condition = alltrue([
      for region in var.source_regions : can(regex("^[a-z0-9-]+$", region))
    ])
    error_message = "resource_aws_securitylake_aws_log_source, source_regions must contain valid AWS region names."
  }
}

variable "source_name" {
  description = "The name for a AWS source. This must be a Regionally unique value."
  type        = string

  validation {
    condition = contains([
      "ROUTE53",
      "VPC_FLOW",
      "SH_FINDINGS",
      "CLOUD_TRAIL_MGMT",
      "LAMBDA_EXECUTION",
      "S3_DATA",
      "EKS_AUDIT",
      "WAF"
    ], var.source_name)
    error_message = "resource_aws_securitylake_aws_log_source, source_name must be one of: ROUTE53, VPC_FLOW, SH_FINDINGS, CLOUD_TRAIL_MGMT, LAMBDA_EXECUTION, S3_DATA, EKS_AUDIT, WAF."
  }
}

variable "source_version" {
  description = "The version for a AWS source. If not specified, the version will be the default. This must be a Regionally unique value."
  type        = string
  default     = null
}