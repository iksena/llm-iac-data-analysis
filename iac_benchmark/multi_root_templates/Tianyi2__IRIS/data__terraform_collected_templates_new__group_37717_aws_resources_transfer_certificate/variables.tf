variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "certificate" {
  description = "The valid certificate file required for the transfer."
  type        = string

  validation {
    condition     = length(var.certificate) > 0
    error_message = "resource_aws_transfer_certificate, certificate must be a non-empty string."
  }
}

variable "certificate_chain" {
  description = "The optional list of certificate that make up the chain for the certificate that is being imported."
  type        = string
  default     = null
}

variable "description" {
  description = "A short description that helps identify the certificate."
  type        = string
  default     = null
}

variable "private_key" {
  description = "The private key associated with the certificate being imported."
  type        = string
  default     = null
  sensitive   = true
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "usage" {
  description = "Specifies if a certificate is being used for signing or encryption. The valid values are SIGNING and ENCRYPTION."
  type        = string

  validation {
    condition     = contains(["SIGNING", "ENCRYPTION"], var.usage)
    error_message = "resource_aws_transfer_certificate, usage must be either 'SIGNING' or 'ENCRYPTION'."
  }
}