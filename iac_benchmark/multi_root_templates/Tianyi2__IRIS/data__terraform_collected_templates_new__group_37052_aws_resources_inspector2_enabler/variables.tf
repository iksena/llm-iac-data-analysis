variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "account_ids" {
  description = "Set of account IDs. Can contain one of: the Organization's Administrator Account, or one or more Member Accounts."
  type        = set(string)

  validation {
    condition     = length(var.account_ids) > 0
    error_message = "resource_aws_inspector2_enabler, account_ids must contain at least one account ID."
  }
}

variable "resource_types" {
  description = "Type of resources to scan. Valid values are EC2, ECR, LAMBDA, LAMBDA_CODE and CODE_REPOSITORY. At least one item is required."
  type        = set(string)

  validation {
    condition     = length(var.resource_types) > 0
    error_message = "resource_aws_inspector2_enabler, resource_types must contain at least one resource type."
  }

  validation {
    condition = alltrue([
      for rt in var.resource_types : contains(["EC2", "ECR", "LAMBDA", "LAMBDA_CODE", "CODE_REPOSITORY"], rt)
    ])
    error_message = "resource_aws_inspector2_enabler, resource_types must contain only valid values: EC2, ECR, LAMBDA, LAMBDA_CODE, CODE_REPOSITORY."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "5m")
    update = optional(string, "5m")
    delete = optional(string, "5m")
  })
  default = {
    create = "5m"
    update = "5m"
    delete = "5m"
  }
}