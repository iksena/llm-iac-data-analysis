variable "arn" {
  description = "ARN of the code signing configuration"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:lambda:[a-zA-Z0-9-]+:[0-9]{12}:code-signing-config:csc-[a-zA-Z0-9]+$", var.arn))
    error_message = "data_aws_lambda_code_signing_config, arn must be a valid Lambda code signing configuration ARN format: arn:aws:lambda:region:account:code-signing-config:csc-id."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "data_aws_lambda_code_signing_config, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}