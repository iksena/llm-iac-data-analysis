variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_verifiedaccess_instance_trust_provider_attachment, region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "verifiedaccess_instance_id" {
  description = "The ID of the Verified Access instance to attach the Trust Provider to."
  type        = string

  validation {
    condition     = can(regex("^vai-[0-9a-f]+$", var.verifiedaccess_instance_id))
    error_message = "resource_aws_verifiedaccess_instance_trust_provider_attachment, verifiedaccess_instance_id must be a valid Verified Access instance ID (e.g., vai-1234567890abcdef0)."
  }
}

variable "verifiedaccess_trust_provider_id" {
  description = "The ID of the Verified Access trust provider."
  type        = string

  validation {
    condition     = can(regex("^vatp-[0-9a-f]+$", var.verifiedaccess_trust_provider_id))
    error_message = "resource_aws_verifiedaccess_instance_trust_provider_attachment, verifiedaccess_trust_provider_id must be a valid Verified Access trust provider ID (e.g., vatp-8012925589)."
  }
}