variable "allowed_publishers_signing_profile_version_arns" {
  description = "Set of ARNs for each of the signing profiles. A signing profile defines a trusted user who can sign a code package."
  type        = set(string)

  validation {
    condition     = length(var.allowed_publishers_signing_profile_version_arns) <= 20
    error_message = "resource_aws_lambda_code_signing_config, allowed_publishers_signing_profile_version_arns can have a maximum of 20 signing profiles."
  }

  validation {
    condition     = length(var.allowed_publishers_signing_profile_version_arns) > 0
    error_message = "resource_aws_lambda_code_signing_config, allowed_publishers_signing_profile_version_arns must contain at least one signing profile ARN."
  }
}

variable "description" {
  description = "Descriptive name for this code signing configuration."
  type        = string
  default     = null
}

variable "policies" {
  description = "Configuration block of code signing policies that define the actions to take if the validation checks fail."
  type = object({
    untrusted_artifact_on_deployment = string
  })
  default = null

  validation {
    condition     = var.policies == null ? true : contains(["Warn", "Enforce"], var.policies.untrusted_artifact_on_deployment)
    error_message = "resource_aws_lambda_code_signing_config, policies.untrusted_artifact_on_deployment must be either 'Warn' or 'Enforce'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the object."
  type        = map(string)
  default     = {}
}