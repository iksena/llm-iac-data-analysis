variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the account setting. One of: BASIC_SCAN_TYPE_VERSION, REGISTRY_POLICY_SCOPE."
  type        = string

  validation {
    condition = contains([
      "BASIC_SCAN_TYPE_VERSION",
      "REGISTRY_POLICY_SCOPE"
    ], var.name)
    error_message = "resource_aws_ecr_account_setting, name must be one of: BASIC_SCAN_TYPE_VERSION, REGISTRY_POLICY_SCOPE."
  }
}

variable "value" {
  description = "Setting value that is specified. Valid values depend on the name parameter."
  type        = string

  validation {
    condition = (
      (var.name == "BASIC_SCAN_TYPE_VERSION" && contains(["AWS_NATIVE", "CLAIR"], var.value)) ||
      (var.name == "REGISTRY_POLICY_SCOPE" && contains(["V1", "V2"], var.value))
    )
    error_message = "resource_aws_ecr_account_setting, value must be AWS_NATIVE or CLAIR when name is BASIC_SCAN_TYPE_VERSION, or V1 or V2 when name is REGISTRY_POLICY_SCOPE."
  }
}