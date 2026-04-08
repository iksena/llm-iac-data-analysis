variable "resource_arn" {
  description = "The Amazon Resource Name (ARN) of the account to create or update a resource policy for"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:redshift-serverless:[a-z0-9-]+:[0-9]{12}:", var.resource_arn))
    error_message = "resource_aws_redshiftserverless_resource_policy, resource_arn must be a valid ARN for Redshift Serverless resources."
  }
}

variable "policy" {
  description = "The policy to create or update. For example, the following policy grants a user authorization to restore a snapshot"
  type        = string

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_redshiftserverless_resource_policy, policy must be a valid JSON string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_redshiftserverless_resource_policy, region must be a valid AWS region format (e.g., us-east-1)."
  }
}