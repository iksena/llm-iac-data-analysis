variable "guardrail_arn" {
  description = "Guardrail ARN."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:bedrock:", var.guardrail_arn))
    error_message = "resource_aws_bedrock_guardrail_version, guardrail_arn must be a valid Bedrock Guardrail ARN starting with 'arn:aws:bedrock:'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the Guardrail version."
  type        = string
  default     = null
}

variable "skip_destroy" {
  description = "Whether to retain the old version of a previously deployed Guardrail."
  type        = bool
  default     = false
}