variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cloudwatch_role_arn" {
  description = "ARN of an IAM role for CloudWatch (to allow logging & monitoring). Logging & monitoring can be enabled/disabled and otherwise tuned on the API Gateway Stage level."
  type        = string
  default     = null

  validation {
    condition     = var.cloudwatch_role_arn == null || can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/", var.cloudwatch_role_arn))
    error_message = "resource_aws_api_gateway_account, cloudwatch_role_arn must be a valid IAM role ARN."
  }
}

