variable "hsm_client_certificate_identifier" {
  description = "The identifier of the HSM client certificate."
  type        = string

  validation {
    condition     = length(var.hsm_client_certificate_identifier) > 0
    error_message = "resource_aws_redshift_hsm_client_certificate, hsm_client_certificate_identifier must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}