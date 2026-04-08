variable "id" {
  description = "The unique identifier of the security configuration."
  type        = string

  validation {
    condition     = length(var.id) > 0
    error_message = "data_aws_opensearchserverless_security_config, id must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region)) || can(regex("^[a-z]{2}-[a-z]+-[0-9][a-z]$", var.region)) || can(regex("^us-gov-[a-z]+-[0-9]$", var.region))
    error_message = "data_aws_opensearchserverless_security_config, region must be a valid AWS region format."
  }
}