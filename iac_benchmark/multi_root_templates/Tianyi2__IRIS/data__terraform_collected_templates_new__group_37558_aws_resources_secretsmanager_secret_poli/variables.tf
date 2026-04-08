variable "policy" {
  description = "Valid JSON document representing a resource policy"
  type        = string

  validation {
    condition     = can(jsondecode(var.policy)) && var.policy != "{}"
    error_message = "resource_aws_secretsmanager_secret_policy, policy must be a valid JSON document and cannot be an empty object '{}'."
  }
}

variable "secret_arn" {
  description = "Secret ARN"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:secretsmanager:", var.secret_arn))
    error_message = "resource_aws_secretsmanager_secret_policy, secret_arn must be a valid AWS Secrets Manager ARN starting with 'arn:aws:secretsmanager:'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "block_public_policy" {
  description = "Makes an optional API call to Zelkova to validate the Resource Policy to prevent broad access to your secret"
  type        = bool
  default     = null
}